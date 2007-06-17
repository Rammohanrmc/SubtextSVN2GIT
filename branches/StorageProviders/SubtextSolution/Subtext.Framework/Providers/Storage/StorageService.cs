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
using System.Web.Configuration;

namespace Subtext.Framework.Providers.Storage
{
    //Handles the providers
	public class StorageService
	{
		private static StorageProvider _provider;
		private static StorageProviderCollection _providers;

		private static object _lock = new object();

		public StorageProvider Provider
		{
			get { return _provider; }
		}

		public StorageProviderCollection Providers
		{
			get { return _providers; }
		}

		private static void SaveFile(Asset asset)
		{
			LoadProviders();
			_provider.SaveFile(asset);
		}
		private static Asset GetFile(string path)
		{
			LoadProviders();
			return _provider.GetFile(path);
		}

		private static void LoadProviders()
		{
			if (_provider == null)
			{
				lock (_lock)
				{
					if (_provider == null)
					{
						StorageProviderServiceSection section = (StorageProviderServiceSection) WebConfigurationManager.GetSection("system.web/fileServer");
						_providers = new StorageProviderCollection();
						ProvidersHelper.InstantiateProviders(section.Providers, _providers, typeof(StorageProvider));
						_providers.SetReadOnly();

						_provider = _providers[section.DefaultProvider];

						if (_provider == null)
						{
							throw new ProviderException("Unable to load default File Provider");
						}
					}
				}
			}
		}

	}
}
