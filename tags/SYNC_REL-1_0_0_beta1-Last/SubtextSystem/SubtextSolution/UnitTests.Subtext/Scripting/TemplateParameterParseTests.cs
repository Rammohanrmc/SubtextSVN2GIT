#region Disclaimer/Info
///////////////////////////////////////////////////////////////////////////////////////////////////
// Subtext WebLog
// 
// Subtext is an open source weblog system that is a fork of the .TEXT
// weblog system.
//
// For updated news and information please visit http://subtextproject.com/
// Subtext is hosted at SourceForge at http://sourceforge.net/projects/subtext
// The development mailing list is at subtext-devs@lists.sourceforge.net 
//
// This project is licensed under the BSD license.  See the License.txt file for more information.
///////////////////////////////////////////////////////////////////////////////////////////////////
#endregion

using System;
using System.IO;
using System.Text;
using MbUnit.Framework;
using Subtext.Scripting;

namespace UnitTests.Subtext.Scripting
{
	/// <summary>
	/// Tests parsing template parameters in a script.
	/// </summary>
	[TestFixture]
	public class TemplateParameterParseTests
	{
		/// <summary>
		/// Tests the contains method.
		/// </summary>
		[Test]
		public void TestContains()
		{
			TemplateParameterCollection collection = new TemplateParameterCollection();
			Assert.IsFalse(collection.Contains("test"), "An empty collection should not contain a parameter.");
			TemplateParameter parameter = new TemplateParameter("test", "type", "something");
			Assert.IsFalse(collection.Contains(parameter), "An empty collection should not contain a parameter.");
			
			collection.Add(parameter);
			Assert.IsTrue(collection.Contains(parameter));
			Assert.IsTrue(collection.Contains("test"));

			TemplateParameter differentParameter = new TemplateParameter("differentName", "", "");
			Assert.IsFalse(collection.Contains(differentParameter), "Contains should not be a \"yes\" method.");
			Assert.IsFalse(collection.Contains(differentParameter.Name), "Contains should not be a \"yes\" method.");

			TemplateParameter newParameterWithSameName = new TemplateParameter("test", "type", "something");
			Assert.IsTrue(collection.Contains(newParameterWithSameName), "Even though this is a separate instance, we match parameters by name. So we should already contain this one.");
		}

		/// <summary>
		/// Tests parsing simple scripts with template parameters.
		/// </summary>
		/// <param name="scriptText">The script.</param>
		/// <param name="name">The name.</param>
		/// <param name="dataType">Type of the data.</param>
		/// <param name="defaultValue">The default value.</param>
		[RowTest]
		[Row("<name,varchar(100),'default'>", "name", "varchar(100)", "'default'")]
		[Row("XYZ <name,varchar(100),'default'> ABC", "name", "varchar(100)", "'default'")]
		[Row("<name ,  varchar(100)		, 'default' >", "name ", "varchar(100)		", "'default' ")]
		[Row("<name, int,10>", "name", "int", "10")]
		[Row("<name, int,>", "name", "int", "")]
		[Row("<name, int, 10>", "name", "int", "10")]
		public void TestParseSimpleScripts(string scriptText, string name, string dataType, string defaultValue)
		{
			Script script = new Script(scriptText);
			TemplateParameterCollection parameters = script.TemplateParameters;
			Assert.AreEqual(1, parameters.Count, "Expected one parameter.");
			TemplateParameter parameter = parameters[0];
			Assert.AreEqual(name, parameter.Name, "Parameter name was not parsed correctly.");
			Assert.AreEqual(dataType, parameter.DataType, "Data Type was not parsed correctly.");
			Assert.AreEqual(defaultValue, parameter.Value, "DefaultValue was not parsed correctly.");
		}

		/// <summary>
		/// Tests parsing simple scripts with template parameters.
		/// </summary>
		/// <param name="scriptText">The script.</param>
		/// <param name="replaceValue"></param>
		/// <param name="expectedResult"></param>
		[RowTest]
		[Row("<name,varchar(100),'default'>", "'MyValue'", "'MyValue'")]
		[Row("<name ,  varchar(100)		, default >", "default", "default")]
		[Row("ABC <name ,  varchar(100)		, default > XYZ", "default", "ABC default XYZ")]
		[Row("<name, int,10>", "15", "15")]
		[Row("ABC<name, int,10>XYZ", "15", "ABC15XYZ")]
		[Row("<name, int,>", "", "")]
		public void TestReplaceSimpleScripts(string scriptText, string replaceValue, string expectedResult)
		{
			Script script = new Script(scriptText);
			script.TemplateParameters[0].Value = replaceValue;
			Assert.AreEqual(expectedResult, script.ScriptText, "Expected a replacement to occur.");
		}

		/// <summary>
		/// Tests parsing simple scripts with template parameters that have default values.
		/// </summary>
		/// <param name="scriptText">The script.</param>
		/// <param name="expectedResult"></param>
		[RowTest]
		[Row("<name,varchar(100),'default'>", "'default'")]
		[Row("<name ,  varchar(100)		, default >", "default ")]
		[Row("ABC <name ,  varchar(100)		, default > XYZ", "ABC default  XYZ")]
		[Row("<name, int,10>", "10")]
		[Row("ABC<name, int,10>XYZ", "ABC10XYZ")]
		[Row("<name, int,>", "")]
		[Row("AND DateAdded < DateAdd(day, 1, @StopDate) AND PostConfig & 1 <> CASE ", "AND DateAdded < DateAdd(day, 1, @StopDate) AND PostConfig & 1 <> CASE ")]
		public void TestReplaceSimpleScriptsWithDefaults(string scriptText, string expectedResult)
		{
			Script script = new Script(scriptText);
			Assert.AreEqual(expectedResult, script.ScriptText, "Expected a replacement to occur.");
		}

		/// <summary>
		/// Tests the more complex script.
		/// </summary>
		/// <remarks>
		/// The script itself is non-sensical, but that's not the point.
		/// </remarks>
		[Test]
		public void TestMoreComplexScript()
		{
			string scriptText = "<name,varchar,default>SELECT * FROM <name,varchar,default> WHERE " + Environment.NewLine 
				+ "<name,varchar,default> = <name2,int,10> and <name3,decimal,>";

			Script script = new Script(scriptText);
			script.TemplateParameters.SetValue("name", "subtext_Config");
			script.TemplateParameters.SetValue("name3", "'32'");

			string expected = "subtext_ConfigSELECT * FROM subtext_Config WHERE " + Environment.NewLine 
				+ "subtext_Config = 10 and '32'";

			Assert.AreEqual(expected, script.ScriptText, "The template replacements failed");
		}

		/// <summary>
		/// Tests expanding a templated collection of scripts without changing any defaults.
		/// </summary>
		[Test]
		public void TestScriptCollectionsDefaultExpansion()
		{
			Stream stream = UnitTestHelper.UnpackEmbeddedResource("Scripting.TestTemplateSqlScript.txt");
			SqlScriptRunner scriptRunner = new SqlScriptRunner(stream, Encoding.UTF8);
			Assert.AreEqual(5, scriptRunner.TemplateParameters.Count, "Not the expected number of template parameters. Make sure it merges correctly.");

			string expectedDefault = UnitTestHelper.UnpackEmbeddedResource("Scripting.TestTemplateSqlScriptExpectedDefault.txt", Encoding.UTF8);
			Assert.AreEqual(expectedDefault, scriptRunner.ScriptCollection.ExpandedScriptText);
		}

		/// <summary>
		/// Tests expanding a templated collection of scripts with changes to the defaults.
		/// </summary>
		[Test]
		public void TestScriptCollectionsExpansionWithChanges()
		{
			Stream stream = UnitTestHelper.UnpackEmbeddedResource("Scripting.TestTemplateSqlScript.txt");
			SqlScriptRunner scriptRunner = new SqlScriptRunner(stream, Encoding.UTF8);
			Assert.AreEqual(5, scriptRunner.TemplateParameters.Count, "Not the expected number of template parameters. Make sure it merges correctly.");

			string expectedDefault = UnitTestHelper.UnpackEmbeddedResource("Scripting.TestTemplateSqlScriptExpectedChanges.txt", Encoding.UTF8);
			
			scriptRunner.TemplateParameters["subtext_db_name"].Value = "SubtextDB";
			scriptRunner.TemplateParameters["dottext_db_name"].Value = "dbDotText";
			scriptRunner.TemplateParameters["dotTextDbUser"].Value = "haacked";
			scriptRunner.TemplateParameters["someOtherTemplate"].Value = "NotABlogId";
			
			string expected = expectedDefault.Trim();
			string result = scriptRunner.ScriptCollection.ExpandedScriptText.Trim();
			expected = expected.Replace("" + (char)13, ""); //Ugly hack!  I know. I'll Explain later.
			result = result.Replace("" + ((char)13), ""); //Ugly hack!  I know. I'll Explain later.

			UnitTestHelper.AssertStringsEqualCharacterByCharacter(expected, result);
			//Assert.AreEqual(expected, result, "Did not expand the template params properly.");
		}
	}
}
