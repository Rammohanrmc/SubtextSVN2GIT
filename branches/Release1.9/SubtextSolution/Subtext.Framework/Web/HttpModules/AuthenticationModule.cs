using System;
using System.Security.Principal;
using System.Web;
using System.Web.Security;
using log4net;
using Subtext.Framework.Text;
using Subtext.Framework.Configuration;

namespace Subtext.Web.HttpModules
{
    /// <summary>
    /// Handles the AuthenticateRequest event of a request.  Decrypts the authentication 
    /// token and sets up the current user as a GeneralPrinciple, attaching its roles.  
    /// </summary>
    public class AuthenticationModule : IHttpModule
    {
        private readonly static ILog log = new Subtext.Framework.Logging.Log();
        
        public void Init(HttpApplication context)
        {
            context.AuthenticateRequest += OnAuthenticateRequest;
        }

        void OnAuthenticateRequest(object sender, EventArgs e)
        {
			HttpCookie authCookie = Subtext.Framework.Security.SelectAuthenticationCookie();

            if (null == authCookie)
            {
                // There is no authentication cookie.
				log.Debug("There is no authentication cookie.");
				return;
            }

			FormsAuthenticationTicket authTicket;
            try
            {
                authTicket = FormsAuthentication.Decrypt(authCookie.Value);
            }
            catch (Exception ex)
            {
                log.Error("Could not decrypt the authentication cookie.", ex);
				HttpContext.Current.Response.Cookies.Add(Subtext.Framework.Security.GetExpiredCookie());			
                return;
            }

            if (null == authTicket)
            {
                log.Warn("Could not decrypt the authentication cookie. No exception was thrown.");
                HttpContext.Current.Response.Cookies.Add(Subtext.Framework.Security.GetExpiredCookie());			
                return;
            }

            if (authTicket.Expired)
            {
                log.Debug("Authentication ticket expired.");
				HttpContext.Current.Response.Cookies.Add(Subtext.Framework.Security.GetExpiredCookie());
                return;
            }

			if (System.Web.Security.FormsAuthentication.SlidingExpiration)
			{
			    System.Web.Security.FormsAuthentication.RenewTicketIfOld(authTicket);
			}

            // When the ticket was created, the UserData property was assigned a
            // pipe delimited string of role names.
            string[] roles = authTicket.UserData.Split(new char[] { '|' });
            // Create an Identity object
            FormsIdentity id = new FormsIdentity(authTicket);

            // This principal will flow throughout the request.
            GenericPrincipal principal = new GenericPrincipal(id, roles);
            // Attach the new principal object to the current HttpContext object
            HttpContext.Current.User = principal;
			log.Debug("Authentication succeeded. Current.User=" + id.Name + "; " + authTicket.UserData);
        }

        public void Dispose()
        {
            //Do Nothing...
        }
    }
}
