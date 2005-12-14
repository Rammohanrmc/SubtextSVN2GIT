using System;
using System.Configuration;
using System.Xml;
using blowery.Web.HttpModules;

namespace Subtext.Framework.Syndication.Compression
{
	public class SyndicationCompressionSettings
	{
		private CompressionTypes _type;
		private CompressionLevels _level;
		private static readonly SyndicationCompressionSettings DefaultSettings = new SyndicationCompressionSettings();
		
		/*-- Constructors --*/

		#region -- Constructor(XmlNode) --
		public SyndicationCompressionSettings(XmlNode node) : this()
		{
			if(node == null)
			{
				return;
			}

			_type = (CompressionTypes)this.RetrieveEnumFromAttribute(node.Attributes["type"], typeof(CompressionTypes));
			_level = (CompressionLevels)this.RetrieveEnumFromAttribute(node.Attributes["level"], typeof(CompressionLevels));
		}
		#endregion

		#region -- Constructor() --
		private SyndicationCompressionSettings()
		{
			_type = CompressionTypes.Deflate;
			_level = CompressionLevels.Normal;
		}
		#endregion

		/*-- Properties --*/

		#region -- CompressionLevel Property --
		public CompressionLevels CompressionLevel
		{
			get
			{
				return _level;
			}
		}
		#endregion

		#region -- CompressionType Property --
		public CompressionTypes CompressionType
		{
			get
			{
				return _type;
			}
		}
		#endregion

		/*-- Methods --*/

		#region -- RetrieveEnumFromAttribute(XmlAttribute, Type) Method --
		protected Enum RetrieveEnumFromAttribute(XmlAttribute attribute, System.Type type)
		{
			return (Enum)Enum.Parse(type, attribute.Value, true);
		}
		#endregion

		/*-- Static Methods --*/

		#region -- GetSettings() Method --
		public static SyndicationCompressionSettings GetSettings()
		{
			SyndicationCompressionSettings settings;
			
			settings = (SyndicationCompressionSettings)ConfigurationSettings.GetConfig("SyndicationCompression");

			if(settings == null)
			{
				settings = SyndicationCompressionSettings.DefaultSettings;
			}
			
			return settings;
		}
		#endregion
	}
}
