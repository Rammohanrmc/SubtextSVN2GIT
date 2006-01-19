using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Text.RegularExpressions;
using Subtext.Scripting.Exceptions;

namespace Subtext.Scripting
{
	/// <summary>
	/// Represents a single executable script within the full SQL script.
	/// </summary>
	public class Script : IScript, ITemplateScript
	{
		ScriptToken _scriptTokens = null;
		TemplateParameterCollection _parameters = null;

		/// <summary>
		/// Helper method which given a full SQL script, returns 
		/// a <see cref="ScriptCollection"/> of individual <see cref="TemplateParameter"/> 
		/// using "GO" as the delimiter.
		/// </summary>
		/// <param name="fullScriptText">Full script text.</param>
		public static ScriptCollection ParseScripts(string fullScriptText)
		{
			Regex regex = new Regex(@"(^\s*|\s+)GO(\s+|\s*$)",  RegexOptions.Multiline | RegexOptions.IgnoreCase | RegexOptions.Compiled);
			string[] scriptTexts = regex.Split(fullScriptText);
			ScriptCollection scripts = new ScriptCollection(fullScriptText);
			foreach(string scriptText in scriptTexts)
			{
				if(scriptText.Trim() != string.Empty)
				{
					scripts.Add(new Script(scriptText));
				}

			}
			return scripts;
		}

		string _scriptText;
		/// <summary>
		/// Creates a new <see cref="TemplateParameter"/> instance.
		/// </summary>
		/// <param name="scriptText">Script text.</param>
		public Script(string scriptText)
		{
			_scriptText = scriptText;
		}

		/// <summary>
		/// Gets the script text.
		/// </summary>
		/// <value></value>
		public string ScriptText
		{
			get
			{
				return ApplyTemplateReplacements();
			}
		}

		/// <summary>
		/// Executes this script.
		/// </summary>
		public int Execute(SqlTransaction transaction)
		{
			int returnValue = 0;
			try
			{
				returnValue = SqlHelper.ExecuteNonQuery(transaction, CommandType.Text, this.ScriptText);
				return returnValue;
			}
			catch(SqlException e)
			{
				throw new SqlScriptExecutionException("Error in executing the script: " + this.ScriptText, this, returnValue, e);
			}
		}

		/// <summary>
		/// Gets the template parameters embedded in the script.
		/// </summary>
		/// <returns></returns>
		public TemplateParameterCollection TemplateParameters
		{
			get
			{
				if(_parameters == null)
				{
					_parameters = new TemplateParameterCollection();

					if(this._scriptText.Length == 0)
						return _parameters;

					Regex regex = new Regex(@"<\s*(?<name>[^()\[\]>,]*)\s*,\s*(?<type>[^>,]*)\s*,\s*(?<default>[^>,]*)\s*>", RegexOptions.Compiled);
					MatchCollection matches = regex.Matches(this._scriptText);
			
					_scriptTokens = new ScriptToken();
			
					int lastIndex = 0;
					foreach(Match match in matches)
					{
						if(match.Index > 0)
						{
							string textBeforeMatch = this._scriptText.Substring(lastIndex, match.Index - lastIndex);
							_scriptTokens.Append(textBeforeMatch);
						}

						lastIndex = match.Index + match.Length;
						TemplateParameter parameter = _parameters.Add(match);
						_scriptTokens.Append(parameter);
					}
					string textAfterLastMatch = this._scriptText.Substring(lastIndex);
					if(textAfterLastMatch.Length > 0)
						_scriptTokens.Append(textAfterLastMatch);
				}
				return _parameters;
			}
		}

		string ApplyTemplateReplacements()
		{
			StringBuilder builder = new StringBuilder();
			if(_scriptTokens == null && TemplateParameters == null)
			{
				throw new InvalidOperationException("The Template parameters are null. This is impossible.");
			}
			_scriptTokens.AggregateText(builder);
			return builder.ToString();
		}

		/// <summary>
		/// Returns the text of the script.
		/// </summary>
		/// <returns>
		/// A <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
		/// </returns>
		public override string ToString()
		{
			if(_scriptTokens != null)
				return this._scriptTokens.ToString();
			return "Script has no tokens.";
		}

		/// <summary>
		/// Implements a linked list representing the script.  This maps the structure 
		/// of a script making it trivial to replace template parameters with their 
		/// values.
		/// </summary>
		class ScriptToken
		{
			/// <summary>
			/// Initializes a new instance of the <see cref="ScriptToken"/> class.
			/// </summary>
			internal ScriptToken()
			{}

			/// <summary>
			/// Initializes a new instance of the <see cref="ScriptToken"/> class.
			/// </summary>
			/// <param name="text">The text.</param>
			internal ScriptToken(string text)
			{
				_text = text;	
			}

			/// <summary>
			/// Gets the text.
			/// </summary>
			/// <value>The text.</value>
			public virtual string Text
			{
				get { return _text; }
			}

			string _text;

			/// <summary>
			/// Gets or sets the next node.
			/// </summary>
			/// <value>The next.</value>
			public ScriptToken Next
			{
				get { return _next; }
				set {_next = value;}
			}

			ScriptToken _next;

			/// <summary>
			/// Gets the last node.
			/// </summary>
			/// <value>The last.</value>
			public ScriptToken Last
			{
				get
				{
					ScriptToken last = this;
					ScriptToken next = _next;
				
					while(next != null)
					{
						last = next;
						next = last.Next;
					}
					return last;
				}
			}

			/// <summary>
			/// Appends the specified text.
			/// </summary>
			/// <param name="text">The text.</param>
			internal void Append(string text)
			{
				this.Last.Next = new ScriptToken(text);
			}

			internal void Append(TemplateParameter parameter)
			{
				this.Last.Next = new TemplateParameterToken(parameter);
			}

			internal void AggregateText(StringBuilder builder)
			{
				builder.Append(this.Text);
				if(this.Next != null)
					this.Next.AggregateText(builder);
			}

			/// <summary>
			/// Returns a <see cref="T:System.String"/> that represents the current <see cref="ScriptToken"/>.
			/// </summary>
			/// <returns>
			/// A <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
			/// </returns>
			public override string ToString()
			{
				int length = 0;
				if(this.Text != null)
					length = this.Text.Length;
				string result = string.Format(@"<ScriptToken length=""{0}"">{1}", length, Environment.NewLine);
				if(this.Next != null)
					result += Next.ToString();
				return result;
			}

		}

		/// <summary>
		/// Represents a template parameter within a script.  This is specialized node 
		/// within the ScriptToken linked list.
		/// </summary>
		class TemplateParameterToken : ScriptToken
		{
			TemplateParameter _parameter = null;

			internal TemplateParameterToken(TemplateParameter parameter)
			{
				_parameter = parameter;
			}

			/// <summary>
			/// Gets the text of this node.
			/// </summary>
			/// <value>The text.</value>
			public override string Text
			{
				get
				{
					return _parameter.Value;
				}
			}

			internal TemplateParameter Parameter
			{
				get
				{
					return _parameter;
				}
			}

			/// <summary>
			/// Returns a <see cref="T:System.String"/> that represents the current <see cref="TemplateParameterToken"/>.
			/// </summary>
			/// <returns>
			/// A <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
			/// </returns>
			public override string ToString()
			{
				string result = "<TemplateParameter";
				if(this._parameter != null)
				{
					result += string.Format(@" name=""{0}"" value=""{1}"" type=""{2}""", _parameter.Name, _parameter.Value, _parameter.DataType);
				}
				result += " />" + Environment.NewLine;
				if(this.Next != null)
					result += Next.ToString();
				return result;
			}

		}
	}
}
