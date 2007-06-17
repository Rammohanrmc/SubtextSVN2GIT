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

using System;
using System.Collections.Generic;
using System.Text;

namespace Subtext.Framework.Providers.Storage
{
    public class SqlAssetProvider : StorageProvider
    {
        public override void SaveAsset(Asset asset)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override Asset GetAsset(string path)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override void Move(string oldPath, string newPath)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override void Delete(string path)
        {
            throw new Exception("The method or operation is not implemented.");
        }
    }
}
