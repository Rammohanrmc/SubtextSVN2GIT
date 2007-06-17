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
    public sealed class StorageService
    {
        private StorageProvider _provider;
        private StorageProviderCollection _providers;

        private static object _lock = new object();

        private static StorageService _instance;

        private StorageService()
        {
            LoadProviders();
        }

        public StorageService Instance()
        {
            if (_instance == null)
            {
                lock (_lock)
                {
                    //Double Null Check
                    if (_instance == null)
                    {
                        _instance = new StorageService();
                    }
                }
            }

            return _instance;
        }

        public StorageProvider Provider
        {
            get { return _provider; }
        }

        public StorageProviderCollection Providers
        {
            get { return _providers; }
        }

        public void SaveAsset(Asset asset)
        {
            _provider.SaveAsset(asset);
        }

        public Asset GetAsset(string path)
        {
            return _provider.GetAsset(path);
        }

        public void Delete(string path)
        {
            _provider.Delete(path);
        }

        public void Move(string oldPath, string newPath)
        {
            _provider.Move(oldPath, newPath);
        }

        private void LoadProviders()
        {
            if (_provider == null)
            {
                StorageProviderServiceSection section = (StorageProviderServiceSection)WebConfigurationManager.GetSection("system.web/assetProvider");
                _providers = new StorageProviderCollection();
                ProvidersHelper.InstantiateProviders(section.Providers, _providers, typeof(StorageProvider));
                _providers.SetReadOnly();

                _provider = _providers[section.DefaultProvider];

                if (_provider == null)
                {
                    throw new ProviderException("Unable to load default Asset Provider");
                }
            }
        }
    }
}
