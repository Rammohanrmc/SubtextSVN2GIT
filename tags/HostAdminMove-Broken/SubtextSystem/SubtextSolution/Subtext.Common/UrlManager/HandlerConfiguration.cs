using System;
using System.Configuration;
using System.Web;
using System.Xml.Serialization;

namespace Subtext.Common.UrlManager
{
	/// <summary>
	/// Configuration class for the HandlerConfiguration section of 
	/// the web.config file.
	/// </summary>
	public class HandlerConfiguration
	{
		/// <summary>
		/// Sets the controls.
		/// </summary>
		/// <param name="context">Context.</param>
		/// <param name="controls">Controls.</param>
		public static void SetControls(HttpContext context, string[] controls)
		{
			if(controls != null)
			{
				context.Items.Add("Subtext.Common.UrlManager.ControlContext", controls);
			}
		}

		/// <summary>
		/// Gets the controls associated to the specified context.
		/// </summary>
		/// <param name="context">Context.</param>
		public static string[] GetControls(HttpContext context)
		{
			return (string[])context.Items["Subtext.Common.UrlManager.ControlContext"];
		}

		private HttpHandler[] _httpHandlers;
		/// <summary>
		/// Gets or sets the HTTP handlers configured in the HttpHandlers section.
		/// </summary>
		/// <value></value>
		[XmlArray("HttpHandlers")]
		public HttpHandler[] HttpHandlers
		{
			get {return this._httpHandlers;}
			set {this._httpHandlers = value;}
		}

		private string _defaultPageLocation;
		/// <summary>
		/// Gets or sets the defualt page location.
		/// </summary>
		/// <value></value>
		[XmlAttribute("defaultPageLocation")]
		public string DefaultPageLocation
		{
			get {return this._defaultPageLocation;}
			set {this._defaultPageLocation = value;}
		}

		private string _fullPageLocation;
		/// <summary>
		/// Gets the full page location.
		/// </summary>
		/// <value></value>
		public string FullPageLocation
		{
			get {
				if(this._fullPageLocation == null)
				{
					this._fullPageLocation = HttpContext.Current.Request.MapPath("~/" + DefaultPageLocation);
				}
				return this._fullPageLocation;
			}
		}

		/// <summary>
		/// returns an instance of the HandlerConfiguration from 
		/// the configuration settings.
		/// </summary>
		/// <returns></returns>
		public static HandlerConfiguration Instance()
		{
			return ((HandlerConfiguration)ConfigurationSettings.GetConfig("HandlerConfiguration"));
		}
	}
}
