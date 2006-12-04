using System;
using MbUnit.Framework;
using Subtext.Framework.Text;

namespace UnitTests.Subtext.Framework.Text
{
	/// <summary>
	/// Summary description for StringHelperTests.
	/// </summary>
	[TestFixture]
	public class StringHelperTests
	{
		/// <summary>
		/// Tests that we can properly pascal case text.
		/// </summary>
		/// <remarks>
		/// Does not remove punctuation.
		/// </remarks>
		/// <param name="original"></param>
		/// <param name="expected"></param>
		[RowTest]
		[Row("", "")]
		[Row("a", "A")]
		[Row("A", "A")]
		[Row("A B", "AB")]
		[Row("a bee keeper's dream.", "ABeeKeeper'sDream.")]
		public void PascalCaseTests(string original, string expected)
		{
			Assert.AreEqual(expected, StringHelper.PascalCase(original));
		}

		[Test]
		[ExpectedException(typeof(ArgumentNullException))]
		public void PascalCaseThrowsArgumentNullException()
		{
			StringHelper.PascalCase(null);
		}
		
		[RowTest]
		[Row("BLAH Tast", "a", 6, StringComparison.Ordinal)]
		[Row("BLAH Tast", "a", 2, StringComparison.InvariantCultureIgnoreCase)]
		public void IndexOfHandlesCaseSensitivity(string source, string search, int expectedIndex, StringComparison comparison)
		{
			Assert.AreEqual(expectedIndex, source.IndexOf(search, comparison), "Did not find the string '{0}' at the index {1}", search, expectedIndex);
		}
		
		[RowTest]
		[Row("Blah/Default.aspx", "Default.aspx", "Blah/", StringComparison.Ordinal)]
		[Row("Blah/Default.aspx", "default.aspx", "Blah/", StringComparison.InvariantCultureIgnoreCase)]
		[Row("Blah/Default.aspx", "default.aspx", "Blah/Default.aspx", StringComparison.Ordinal)]
		public void LeftBeforeOfHandlesCaseSensitivity(string source, string search, string expected, StringComparison comparison)
		{
			Assert.AreEqual(expected, StringHelper.LeftBefore(source, search, comparison), "Truncating did not return the correct result.");
		}
		
		[Test]
		[ExpectedArgumentNullException]
		public void JoinThrowsArgumentNullExceptionForNullDelimiter()
		{
			StringHelper.Join<Object>(null, new string[] {""}, delegate(Object item)
			{
				return item.ToString();
			});
		}

		[Test]
		[ExpectedArgumentNullException]
		public void JoinThrowsArgumentNullExceptionForNullCollection()
		{
			StringHelper.Join<Object>("|", null, delegate(Object item)
			{
				return item.ToString();
			});
		}

		[Test]
		[ExpectedArgumentNullException]
		public void JoinThrowsArgumentNullExceptionForNullDelegate()
		{
			StringHelper.Join<Object>("|", new string[] {""}, null);
		}

		[Test]
		public void JoinTCanJoinCorrectly()
		{
			string joined = StringHelper.Join<string>("|-", new string[] { "a", "b", "c" }, delegate(string item)
			{
				return item;
			});
			
			Assert.AreEqual("a|-b|-c", joined, "Join did not delimit correctly.");
		}
	}
}
