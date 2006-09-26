using System;
using System.ComponentModel;
using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Subtext.Web.Controls
{
	/// <summary>
	/// <para>Simple CAPTCHA control that requires the browser to perform a 
	/// simple calculation via javascript to pass.  
	/// </para>
	/// <para>
	/// If javascript is not enabled, a form is rendered asking the user to add two random 
	/// small numbers, unless the <see cref="Accessible" />  property is set to false.
	/// </para>
	/// </summary>
	public class InvisibleCaptcha : BaseValidator
	{
		Random rnd = new Random();
		string directions = string.Empty;
		
		/// <summary>
		/// Initializes a new instance of the <see cref="InvisibleCaptcha"/> class.
		/// </summary>
		public InvisibleCaptcha() : base()
		{
		}

		/// <summary>
		/// Gets or sets a value indicating whether this <see cref="InvisibleCaptcha"/> is accessible 
		/// to non-javascript browsers.  If false, then non-javascript browsers will always fail 
		/// validation.
		/// </summary>
		/// <value><c>true</c> if accessible; otherwise, <c>false</c>.</value>
		[Description("Determines whether or not this control will work for non-javascript enabled browsers")]
		[DefaultValue(true)]
		[Browsable(true)]
		[Category("Behavior")]
		public bool Accessible
		{
			get { return (bool)(ViewState["Accessible"] ?? true); }
			set { ViewState["Accessible"] = value; }
		}

		/// <summary>
		/// Sets up a hashed answer.
		/// </summary>
		/// <param name="e"></param>
		protected override void OnInit(EventArgs e)
		{
			Page.RegisterRequiresControlState(this);
			
			Page.ClientScript.RegisterHiddenField(HiddenAnswerFieldName, "");
			base.OnInit(e);
		}

		/// <summary>
		/// Raises the <see cref="E:System.Web.UI.Control.PreRender"></see> event.
		/// </summary>
		/// <param name="e">A <see cref="T:System.EventArgs"></see> that contains the event data.</param>
		protected override void OnPreRender(EventArgs e)
		{
			int first = rnd.Next(1, 9);
			int second = rnd.Next(1, 9);

			directions = string.Format("Please add {0} and {1} and type the answer here: ", first, second);
			Display = ValidatorDisplay.Dynamic;
			
			string answer = (first + second).ToString(CultureInfo.InvariantCulture);
			//A little obsfucation.
			Page.ClientScript.RegisterHiddenField(HiddenAnswerHashFieldName, Convert.ToBase64String(Encoding.UTF8.GetBytes(answer)));

			Page.ClientScript.RegisterStartupScript(typeof(InvisibleCaptcha), "MakeCaptchaInvisible", string.Format("<script type=\"text/javascript\">\r\nsubtext_invisible_captcha_hideFromJavascriptEnabledBrowsers('{0}');\r\n</script>", this.CaptchaInputClientId));
			
			Page.ClientScript.RegisterClientScriptInclude("InvisibleCaptcha",
				 Page.ClientScript.GetWebResourceUrl(this.GetType(), "Subtext.Web.Controls.Resources.InvisibleCaptcha.js"));

			Page.ClientScript.RegisterStartupScript(typeof(InvisibleCaptcha), "ComputeCaptchaAnswer", string.Format("<script type=\"text/javascript\">\r\nsubtext_invisible_captcha_setAnswer({0}, {1}, '{2}');\r\n</script>", first, second, this.HiddenAnswerFieldName));
			base.OnPreRender(e);
		}

		/// <summary>
		/// Displays the control on the client.
		/// </summary>
		/// <param name="writer">A <see cref="T:System.Web.UI.HtmlTextWriter"></see> that contains the output stream for rendering on the client.</param>
		protected override void Render(HtmlTextWriter writer)
		{
			string answer = Page.Request.Form[HiddenAnswerFieldName];
			// In an Ajax postback, we don't want to render this if javascript is enabled 
			// because the page won't know to set this span to be invisible.
			if (Accessible && String.IsNullOrEmpty(answer))
			{
				base.Render(writer);
				writer.AddAttribute("id", CaptchaInputClientId);
				if (!string.IsNullOrEmpty(CssClass))
					writer.AddAttribute("class", CssClass);
				writer.RenderBeginTag("span");
				writer.Write(directions);

				writer.Write("<input type=\"text\" name=\"{0}\" value=\"\" />", this.VisibleAnswerFieldName);
				
				writer.RenderEndTag();
			}
		}

		/// <summary>Checks the properties of the control for valid values.</summary>
		/// <returns>true if the control properties are valid; otherwise, false.</returns>
		protected override bool ControlPropertiesValid()
		{
			if (!String.IsNullOrEmpty(ControlToValidate))
			{
				CheckControlValidationProperty(ControlToValidate, "ControlToValidate");
			}
			return true;
		}

		string ComputeAnswerHash(string answer)
		{
			string saltedAnswer = answer + "_" + SecretCode;
			Byte[] clearBytes = Encoding.UTF8.GetBytes(saltedAnswer);
			Byte[] hashedBytes = new MD5CryptoServiceProvider().ComputeHash(clearBytes);
			return Convert.ToBase64String(hashedBytes);
		}
		
		string CaptchaInputClientId
		{
			get
			{
				return this.ClientID + "_subtext_captcha";
			}
		}
		
		string VisibleAnswerFieldName
		{
			get
			{
				return ClientID + "_visibleanswer";
			}
		}
		
		string HiddenAnswerFieldName
		{
			get
			{
				return ClientID + "_answer";
			}
		}

		string HiddenAnswerHashFieldName
		{
			get
			{
				return ClientID + "_answerhash";
			}
		}
		
		string SecretCode
		{
			get
			{
				if(Page.Cache["SecretCode"] == null)
				{
					Page.Cache["SecretCode"] = Guid.NewGuid().ToString();
				}
				return (string)Page.Cache["SecretCode"];
			}
		}
		
		///<summary>
		///When overridden in a derived class, this method contains the code to determine whether the value in the input control is valid.
		///</summary>
		///<returns>
		///true if the value in the input control is valid; otherwise, false.
		///</returns>
		///
		protected override bool EvaluateIsValid()
		{
			string answer = Page.Request.Form[HiddenAnswerFieldName];
			if(String.IsNullOrEmpty(answer))
				answer = Page.Request.Form[VisibleAnswerFieldName];
			string answerHash = ComputeAnswerHash(answer);

			string encodedExpectedAnswer = Page.Request.Form[HiddenAnswerHashFieldName];
			if (String.IsNullOrEmpty(encodedExpectedAnswer))
				return false; //Somebody is tampering with the form.

			string actualAnswer = Encoding.UTF8.GetString(Convert.FromBase64String(encodedExpectedAnswer));
			string expectedAnswerHash = ComputeAnswerHash(actualAnswer);
			return answerHash == expectedAnswerHash;
		}
	}
}
