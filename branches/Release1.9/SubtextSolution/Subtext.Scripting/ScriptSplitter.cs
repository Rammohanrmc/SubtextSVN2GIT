using System;
using System.IO;
using System.Text;
using Subtext.Scripting.Exceptions;

namespace Subtext.Scripting
{
	public class ScriptSplitter
	{
		private ScriptReader scriptReader = null;
		private StringBuilder builder = new StringBuilder();
		protected readonly Action<string> scriptParsed;
		private readonly TextReader reader;
		private char current = char.MinValue;
		private char lastChar = char.MinValue;

		public ScriptSplitter(string script, Action<string> scriptParsed)
		{
			this.reader = new StringReader(script);
			this.scriptParsed = scriptParsed;
			this.scriptReader = new SeparatorLineReader(this);
		}

		public bool Next()
		{
			if (!HasNext)
			{
				SetScriptComplete();
				return false;
			}

			this.lastChar = this.current;
			this.current = (char)reader.Read();
			return true;
		}

		public bool HasNext
		{
			get { return reader.Peek() != -1; }
		}

		public int Peek()
		{
			return reader.Peek();
		}

		public char Current
		{
			get { return this.current; }
		}

		public char LastChar
		{
			get { return this.lastChar; }
		}

		public void Split()
		{
			this.scriptReader.ReadNextSection();
		}

		internal void SetParser(ScriptReader newReader)
		{
			this.scriptReader = newReader;
		}

		internal void Append(string text)
		{
			builder.Append(text);
		}

		internal void Append(char c)
		{
			builder.Append(c);
		}

		public void SetScriptComplete()
		{
			string script = builder.ToString().Trim();
			if(script.Length > 0)
				scriptParsed(builder.ToString());
			Reset();	
		}

		void Reset()
		{
			current = lastChar = char.MinValue;
			builder = new StringBuilder();
		}
	}

	abstract class ScriptReader
	{
		protected readonly ScriptSplitter splitter;
		
		public ScriptReader(ScriptSplitter splitter)
		{
			this.splitter = splitter;
		}
		
		/// <summary>
		/// This acts as a template method. Specific Reader instances 
		/// override the component methods.
		/// </summary>
		public void ReadNextSection()
		{
			if (IsQuote)
			{
				ReadQuotedString();
				return;
			}

			if (BeginDashDashComment)
			{
				ReadDashDashComment();
				return;
			}

			if (BeginSlashStarComment)
			{
				ReadSlashStarComment();
				return;
			}

			ReadNext();
		}

		protected virtual void ReadDashDashComment()
		{
			splitter.Append(Current);
			while (splitter.Next())
			{
				splitter.Append(Current);
				if (EndOfLine)
				{
					this.splitter.SetParser(new SeparatorLineReader(this.splitter));
					return;
				}
			}
		}

		protected virtual void ReadSlashStarComment()
		{
			splitter.Append(Current);
			while (splitter.Next())
			{
				splitter.Append(Current);
				if (EndSlashStarComment)
				{
					splitter.SetParser(new SeparatorLineReader(splitter));
					return;
				}
			}
		}

		protected virtual void ReadQuotedString()
		{
			splitter.Append(Current);
			while (splitter.Next())
			{
				splitter.Append(Current);
				if (IsQuote)
				{
					return;
				}
			}
		}

		protected abstract void ReadNext();

		#region Helper methods and properties
		protected static bool CharEquals(char expected, char actual)
		{
			return Char.ToLowerInvariant(expected) == Char.ToLowerInvariant(actual);
		}

		protected bool CharEquals(char compare)
		{
			return CharEquals(this.Current, compare);
		}

		protected bool HasNext
		{
			get { return this.splitter.HasNext; }
		}

		protected char Peek()
		{
			if (!HasNext)
				return char.MinValue;
			return (char)this.splitter.Peek();
		}

		protected bool WhiteSpace
		{
			get { return char.IsWhiteSpace(this.splitter.Current); }
		}

		protected bool EndOfLine
		{
			get { return '\n' == this.splitter.Current; }
		}

		protected bool IsQuote
		{
			get { return '\'' == this.splitter.Current; }
		}

		protected char Current
		{
			get { return this.splitter.Current; }
		}

		protected char LastChar
		{
			get { return this.splitter.LastChar; }
		}

		bool BeginDashDashComment
		{
			get { return this.Current == '-' && Peek() == '-'; }
		}

		bool BeginSlashStarComment
		{
			get { return this.Current == '/' && Peek() == '*'; }
		}

		bool EndSlashStarComment
		{
			get { return this.LastChar == '*' && this.Current == '/'; }
		}

		protected void AppendCurrent()
		{
			this.splitter.Append(this.Current);
		}

		protected void Append(string text)
		{
			this.splitter.Append(text);
		}
		#endregion
	}

	class SeparatorLineReader : ScriptReader
	{
		private StringBuilder builder = new StringBuilder();
		private bool foundGo;
		private bool gFound;

		public SeparatorLineReader(ScriptSplitter splitter)
			: base(splitter)
		{
		}

		void Reset()
		{
			foundGo = false;
			gFound = false;
			builder = new StringBuilder();
		}

		protected override void ReadSlashStarComment()
		{
			if (foundGo)
				throw new SqlParseException("Incorrect syntax was encountered while parsing GO. Cannot have a slash star /* comment */ after a GO statement.");
			base.ReadSlashStarComment();
		}

		protected override void ReadNext()
		{
			if (EndOfLine) //End of line or script
			{
				if (!foundGo)
				{
					builder.Append(Current);
					splitter.Append(builder.ToString());
					splitter.SetParser(new SeparatorLineReader(splitter));
					return;
				}
				else
				{
					Reset();
					splitter.SetScriptComplete();
					return;
				}
			}

			if (WhiteSpace)
			{
				builder.Append(Current);
				return;
			}

			if (!CharEquals('g') && !CharEquals('o'))
			{
				FoundNonEmptyCharacter(Current);
				return;
			}

			if (CharEquals('o'))
			{
				if (CharEquals('g', LastChar) && !foundGo)
					foundGo = true;
				else
					FoundNonEmptyCharacter(Current);
			}

			if (CharEquals('g', Current))
			{
				if (gFound || (!Char.IsWhiteSpace(LastChar) && LastChar != char.MinValue))
				{
					FoundNonEmptyCharacter(Current);
					return;
				}

				gFound = true;
			}

			if(!HasNext && foundGo)
			{
				Reset();
				splitter.SetScriptComplete();
				return;
			}

			builder.Append(Current);
		}

		void FoundNonEmptyCharacter(char c)
		{
			builder.Append(c);
			splitter.Append(builder.ToString());
			splitter.SetParser(new SqlScriptReader(splitter));
		}	
	}

	class SqlScriptReader : ScriptReader
	{
		public SqlScriptReader(ScriptSplitter splitter)
			: base(splitter)
		{
		}

		protected override void ReadNext()
		{
			if (EndOfLine) //end of line
			{
				splitter.Append(Current);
				splitter.SetParser(new SeparatorLineReader(splitter));
				return;
			}

			splitter.Append(Current);
		}
	}
}
