using System;
using System.Web;
using System.Web.Security;

namespace Subtext.Framework.Security
{
	/// <summary>
	/// Class used to temporarily set the ApplicationName to a different 
	/// application for the purposes of running commands in that application.
	/// </summary>
	public sealed class MembershipApplicationScope : IDisposable
	{
		private MembershipApplicationScope()
		{
		}
		
		/// <summary>
		/// Sets the application name to the specified name temporarily.
		/// Dispose resets the application name back.
		/// </summary>
		/// <param name="applicationName">Name of the application.</param>
		/// <returns></returns>
		public static MembershipApplicationScope SetApplicationName(string applicationName)
		{
			MembershipApplicationScope scope = new MembershipApplicationScope();
			scope.currentApplicationName = Membership.ApplicationName;
            if (HttpContext.Current != null)
            {
                HttpContext.Current.Items[SecurityHelper.CONTEXT_IDX] = applicationName;
            }
            else
            {
                Membership.ApplicationName = Roles.ApplicationName = applicationName;
            }
			return scope;
		}

		string currentApplicationName;
		
		///<summary>
		///Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
		///</summary>
		///<filterpriority>2</filterpriority>
		public void Dispose()
		{
            if (HttpContext.Current != null)
            {
                HttpContext.Current.Items[SecurityHelper.CONTEXT_IDX] = currentApplicationName;
            }
            else
            {
                Membership.ApplicationName = Roles.ApplicationName = currentApplicationName;
            }
		}
	}
}
