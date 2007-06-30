using System;
using System.Collections.Generic;
using System.Text;

namespace Subtext.Framework.Providers.Storage
{
    public interface IAsset
    {
        public string DirectoryName { get; }
        public long Length { get; }
        public override string Name { get; }
    }
}
