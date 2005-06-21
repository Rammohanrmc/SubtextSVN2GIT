// This file contains documentation for the various Namespaces within this assembly.
// These classes are only used by NDoc to generate namespace documentation.
// They should all be internal sealed classes with private constructors.
//
// http://ndoc.sourceforge.net/reference/NDoc.Core.Reflection.BaseReflectionDocumenterConfig.UseNamespaceDocSummaries.html

//#if debug
namespace Subtext.Framework
{
	/// <summary>
	/// Contains the primary framework classes used by 
	/// the Subtext blogging engine.
	/// </summary>
	internal sealed class NamespaceDoc
	{
		private NamespaceDoc()
		{
		}
	}
}

namespace Subtext.Framework.Configuration
{
	/// <summary>
	/// <p>
	/// Contains classes used to read various configuration data 
	/// for Subtext.  Configuration data is generally stored in two places, 
	/// Web.config or the blog_config table.</p>
	/// <p>
	/// Either way, the class to use when accessing any configuration setting 
	/// is the <see cref="Subtext.Framework.Configuration.Config" /> class.  
	/// </p>
	/// <p>
	/// The <see cref="Config.Settings"/> returns an instance of <see cref="BlogConfigurationSettings"/> 
	/// which contains settings configured in a custom section of Web.config (see the &lt;BlogConfigurationSettings&gt; 
	/// tag in Web.config).
	/// </p>
	/// <p>
	/// The <see cref="Config.CurrentBlog"/> method returns an instance of <see cref="BlogInfo"/> 
	/// contains settings stored in the blog_config table.  This can be used to save settings to 
	/// the configuration as well.
	/// </p>
	/// </summary>
	internal sealed class NamespaceDoc
	{
		private NamespaceDoc()
		{
		}
	}
}

namespace Subtext.Framework.Components
{
	/// <summary>
	/// Contains the primary business layer classes such as <see cref="Entry"/>, 
	/// <see cref="Image"/>, <see cref="KeyWord"/>.
	/// </summary>
	internal sealed class NamespaceDoc
	{
		private NamespaceDoc()
		{
		}
	}
}
//#endif
