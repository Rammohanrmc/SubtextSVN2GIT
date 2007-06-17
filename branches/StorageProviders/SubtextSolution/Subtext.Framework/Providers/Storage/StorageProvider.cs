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

using System.Configuration.Provider;

namespace Subtext.Framework.Providers.Storage
{
    //TODO: This needs documenting and work on it.  Very basic.  
	/// <summary>
	/// Defines the abstract class for a provider
	/// </summary>
	public abstract class StorageProvider : ProviderBase
	{
		public abstract void SaveFile(Asset asset);
		public abstract Asset GetFile(string path);
		
		public abstract void Move(string oldPath, string newPath);
		public abstract void Delete(string path);
	}
}
