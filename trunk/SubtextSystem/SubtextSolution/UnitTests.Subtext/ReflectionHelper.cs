using System;
using System.Reflection;

namespace Subtext.Reflection
{
	/// <summary>
	/// Helper class to simplify common reflection tasks.
	/// </summary>
	public sealed class ReflectionHelper
	{
		private ReflectionHelper() {}

		/// <summary>
		/// Returns the value of the private member specified.
		/// </summary>
		/// <param name="fieldName">Name of the member.</param>
		/// <param name="source">The object that contains the member.</param>
		public static object GetStaticField(string fieldName, object source)
		{
			return GetStaticField(fieldName, source, source.GetType());
		}

		/// <summary>
		/// Returns the value of the private member specified.
		/// </summary>
		/// <param name="fieldName">Name of the member.</param>
		/// <param name="type"></param>
		public static object GetStaticField(string fieldName, object source, Type type)
		{
			FieldInfo field = type.GetField(fieldName, BindingFlags.NonPublic | BindingFlags.Static);
			if(field != null)
			{
				return field.GetValue(type);
			}
			return null;
		}

		/// <summary>
		/// Returns the value of the private member specified.
		/// </summary>
		/// <param name="memberName">Name of the member.</param>
		/// <param name="source">The object that contains the member.</param>
		public static object GetPrivateInstanceField(string memberName, object source)
		{
			FieldInfo field = source.GetType().GetField(memberName, BindingFlags.GetField | BindingFlags.NonPublic | BindingFlags.Instance);
			if(field != null)
			{
				return field.GetValue(source);
			}
			return null;
		}
	}
}

