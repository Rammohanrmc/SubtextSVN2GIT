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

namespace Subtext.Framework.Providers.Storage
{

    /// <summary>
    /// This will hold all the information about the Asset (file) from the Storage Provider.
    /// </summary>
    public class Asset : IAsset
    {

        private string _directoryName;
        public string DirectoryName
        {
            get { return _directoryName; }
        }


        private long _length;
        public long Length
        {
            get { return _length; }
        }

        public override string Name
        {
            get { return _name; }
        }

    }
}
