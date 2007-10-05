using System;
using System.Security.Permissions;
using Jayrock.JsonRpc;
using Jayrock.JsonRpc.Web;
using Subtext.Framework;
using Subtext.Framework.Components;
using Subtext.Framework.Configuration;

namespace Subtext.Web.Admin.Services.Ajax
{
    //NOTE: we are now using Jayrock for Ajax services. Please see http://jayrock.berlios.de/ for more info
    public class AjaxServices : JsonRpcHandler
    {
        //[PrincipalPermission(SecurityAction.Demand, Role = "Admins")]
        [JsonRpcMethod("addMetaTagForBlog")]
        public MetaTag AddMetaTagForBlog(string content, string name, string httpEquiv)
        {
            MetaTag newTag = new MetaTag(content);
            newTag.Name = name;
            newTag.HttpEquiv = httpEquiv;
            newTag.BlogId = Config.CurrentBlog.Id;
            newTag.DateCreated = DateTime.Now;

            MetaTags.Create(newTag);

            return newTag;
        }

        [JsonRpcMethod("deleteMetaTag")]
        public bool DeleteMetaTag(int id)
        {
            return MetaTags.Delete(id);
        }
    }
}