<%@ Page language="c#" Title="Subtext Admin - Configure" MasterPageFile="~/Admin/WebUI/AdminPageTemplate.Master" Codebehind="Configure.aspx.cs" Inherits="Subtext.Web.Admin.Pages.Configure" %>
<%@ Register TagPrefix="st" Namespace="Subtext.Web.Admin.WebUI" Assembly="Subtext.Web" %>
<%@ Register TagPrefix="st" Namespace="Subtext.Web.Controls" Assembly="Subtext.Web.Controls" %>
<%@ Register TagPrefix="ajax" Namespace="MagicAjax.UI.Controls" Assembly="MagicAjax" %>

<asp:Content ID="actions" ContentPlaceHolderID="actionsHeading" runat="server">
    Actions
</asp:Content>

<asp:Content ID="categoryListTitle" ContentPlaceHolderID="categoryListHeading" runat="server">
</asp:Content>

<asp:Content ID="categoriesLinkListing" ContentPlaceHolderID="categoryListLinks" runat="server">
</asp:Content>
    
<asp:Content ID="configurationOptions" ContentPlaceHolderID="pageContent" runat="server">
	<st:MessagePanel id="Messages" runat="server"></st:MessagePanel>
	<st:AdvancedPanel id="Edit" runat="server" Collapsible="False" HeaderText="Configure" HeaderCssClass="CollapsibleHeader"
		BodyCssClass="Edit" DisplayHeader="true">
		<fieldset class="options">
			<legend>Main Settings</legend>
			<p>
				<label class="Block" accesskey="t" for="Edit_txbTitle"><u>T</u>itle</label>
				<asp:TextBox id="txbTitle" runat="server" CssClass="textinput"></asp:TextBox>
			</p>
			<p>
				<label class="Block" accesskey="s" for="Edit_txbSubtitle"><u>S</u>ubtitle</label>
				<asp:TextBox id="txbSubtitle" runat="server" CssClass="textinput"></asp:TextBox>
			</p>
			<p>
				<label class="Block" accesskey="u" for="Edit_txbUser"><u>U</u>sername</label>
				<asp:TextBox id="txbUser" runat="server" CssClass="textinput"></asp:TextBox>
			</p>
			<p>
				<label class="Block" accesskey="n" for="Edit_txbAuthor">Owner's Display <u>N</u>ame</label>
				<asp:TextBox id="txbAuthor" runat="server" CssClass="textinput"></asp:TextBox>
			</p>
			<p>
				<label class="Block" accesskey="e" for="Edit_txbAuthorEmail">Owner's <u>E</u>mail</label>
				<asp:TextBox id="txbAuthorEmail" runat="server" CssClass="textinput"></asp:TextBox>
			</p>
			<p>
				<label class="Block" accesskey="s" for="Edit_ddlSkin">Display <u>S</u>kin</label>
				<asp:DropDownList id="ddlSkin" runat="server"></asp:DropDownList>
			</p>
			<p>
				<label accesskey="w" for="Edit_ckbAllowServiceAccess">Allow <u>W</u>eb Service Access</label>
				<asp:CheckBox id="ckbAllowServiceAccess" runat="server"></asp:CheckBox>
			</p>
		</fieldset>
		<fieldset class="options">
			<legend>Location Settings</legend>
			<ajax:ajaxpanel ID="ajaxTimezone" runat="server">
			<p>
				<label class="Block" accesskey="z" for="Edit_ddlTimezone">
					Your Time<u>z</u>one
					<st:HelpToolTip id="hlpTimeZone" runat="server" HelpText="Select your timezone, which may differ from the timezone where your blog server is located." ImageUrl="~/images/icons/help-small.png" ImageWidth="16" ImageHeight="16" />
				</label>
				<asp:DropDownList id="ddlTimezone" runat="server" OnSelectedIndexChanged="ddlTimezone_SelectedIndexChanged" AutoPostBack="true">
					<asp:ListItem Text="Hawaii (GMT -10)" Value="-10" />
					<asp:ListItem Text="Alaska (GMT -9)" Value="-9" />
					<asp:ListItem Text="Pacific Time (GMT -8)" Value="-8" />
					<asp:ListItem Text="Mountain Time (GMT -7)" Value="-7" />
					<asp:ListItem Text="Central Time (GMT -6)" Value="-6" />
					<asp:ListItem Text="Eastern Time (GMT -5)" Value="-5" />
					<asp:ListItem Text="Atlantic Time (GMT -4)" Value="-4" />
					<asp:ListItem Text="Brasilia Time (GMT -3)" Value="-3" />
					<asp:ListItem Text="(GMT -2)" Value="-2" />
					<asp:ListItem Text="(GMT -1)" Value="-1" />
					<asp:ListItem Text="Greenwich Mean Time (GMT +0)" Value="0" />
					<asp:ListItem Text="Central Europe Time (GMT +1)" Value="1" />
					<asp:ListItem Text="Eastern Europe Time (GMT +2)" Value="2" />
					<asp:ListItem Text="Middle Eastern Time (GMT +3)" Value="3" />
					<asp:ListItem Text="Abu Dhabi Time (GMT +4)" Value="4" />
					<asp:ListItem Text="Indian Time (GMT +5)" Value="5" />
					<asp:ListItem Text="Eastern China Time (GMT +8)" Value="8" />
					<asp:ListItem Text="Japan Time (GMT +9)" Value="9" />
					<asp:ListItem Text="Australian Time (GMT +10)" Value="10" />
					<asp:ListItem Text="Pacific Rim Time (GMT +11)" Value="11" />
					<asp:ListItem Text="New Zealand Time (GMT +12)" Value="12" />
				</asp:DropDownList>
			</p>
			<p>
				<em>Time at selected timezone is: <strong><asp:Label ID="lblCurrentTime" runat="server" /></strong></em><br />
				<em>Time at server is: <strong><asp:Label ID="lblServerTime" runat="server" /></strong></em><br />
				<em>Server timezone is <asp:Label ID="lblServerTimeZone" runat="server" />)</em>
			</p>
			</ajax:ajaxpanel>
			<p>
				<label class="Block" accesskey="l" for="Edit_ddlLangLocale"><u>L</u>anguage/Locale</label>
				
				<asp:DropDownList id="ddlLangLocale" runat="server">
					<asp:ListItem Text="Afrikaans" Value="af" />
					<asp:ListItem Text="Afrikaans - South Africa" Value="af-ZA" />
					<asp:ListItem Text="Albanian" Value="sq" />
					<asp:ListItem Text="Albanian - Albania" Value="sq-AL" />
					<asp:ListItem Text="Arabic" Value="ar" />
					<asp:ListItem Text="Arabic - Algeria" Value="ar-DZ" />
					<asp:ListItem Text="Arabic - Bahrain" Value="ar-BH" />
					<asp:ListItem Text="Arabic - Egypt" Value="ar-EG" />
					<asp:ListItem Text="Arabic - Iraq" Value="ar-IQ" />
					<asp:ListItem Text="Arabic - Jordan" Value="ar-JO" />
					<asp:ListItem Text="Arabic - Kuwait" Value="ar-KW" />
					<asp:ListItem Text="Arabic - Lebanon" Value="ar-LB" />
					<asp:ListItem Text="Arabic - Libya" Value="ar-LY" />
					<asp:ListItem Text="Arabic - Morocco" Value="ar-MA" />
					<asp:ListItem Text="Arabic - Oman" Value="ar-OM" />
					<asp:ListItem Text="Arabic - Qatar" Value="ar-QA" />
					<asp:ListItem Text="Arabic - Saudi Arabia" Value="ar-SA" />
					<asp:ListItem Text="Arabic - Syria" Value="ar-SY" />
					<asp:ListItem Text="Arabic - Tunisia" Value="ar-TN" />
					<asp:ListItem Text="Arabic - United Arab Emirates" Value="ar-AE" />
					<asp:ListItem Text="Arabic - Yemen" Value="ar-YE" />
					<asp:ListItem Text="Armenian" Value="hy" />
					<asp:ListItem Text="Armenian - Armenia" Value="hy-AM" />
					<asp:ListItem Text="Azeri" Value="az" />
					<asp:ListItem Text="Azeri (Cyrillic) - Azerbaijan" Value="Cy-az-AZ" />
					<asp:ListItem Text="Azeri (Latin) - Azerbaijan" Value="Lt-az-AZ" />
					<asp:ListItem Text="Basque" Value="eu" />
					<asp:ListItem Text="Basque - Basque" Value="eu-ES" />
					<asp:ListItem Text="Belarusian" Value="be" />
					<asp:ListItem Text="Belarusian - Belarus" Value="be-BY" />
					<asp:ListItem Text="Bulgarian" Value="bg" />
					<asp:ListItem Text="Bulgarian - Bulgaria" Value="bg-BG" />
					<asp:ListItem Text="Catalan" Value="ca" />
					<asp:ListItem Text="Catalan - Catalan" Value="ca-ES" />
					<asp:ListItem Text="Chinese - Hong Kong SAR" Value="zh-HK" />
					<asp:ListItem Text="Chinese - Macau SAR" Value="zh-MO" />
					<asp:ListItem Text="Chinese - China" Value="zh-CN" />
					<asp:ListItem Text="Chinese (Simplified)" Value="zh-CHS" />
					<asp:ListItem Text="Chinese - Singapore" Value="zh-SG" />
					<asp:ListItem Text="Chinese - Taiwan" Value="zh-TW" />
					<asp:ListItem Text="Chinese (Traditional)" Value="zh-CHT" />
					<asp:ListItem Text="Croatian" Value="hr" />
					<asp:ListItem Text="Croatian - Croatia" Value="hr-HR" />
					<asp:ListItem Text="Czech" Value="cs" />
					<asp:ListItem Text="Czech - Czech Republic" Value="cs-CZ" />
					<asp:ListItem Text="Danish" Value="da" />
					<asp:ListItem Text="Danish - Denmark" Value="da-DK" />
					<asp:ListItem Text="Dhivehi" Value="div" />
					<asp:ListItem Text="Dhivehi - Maldives" Value="div-MV" />
					<asp:ListItem Text="Dutch" Value="nl" />
					<asp:ListItem Text="Dutch - Belgium" Value="nl-BE" />
					<asp:ListItem Text="Dutch - The Netherlands" Value="nl-NL" />
					<asp:ListItem Text="English" Value="en" />
					<asp:ListItem Text="English - Australia" Value="en-AU" />
					<asp:ListItem Text="English - Belize" Value="en-BZ" />
					<asp:ListItem Text="English - Canada" Value="en-CA" />
					<asp:ListItem Text="English - Caribbean" Value="en-CB" />
					<asp:ListItem Text="English - Ireland" Value="en-IE" />
					<asp:ListItem Text="English - Jamaica" Value="en-JM" />
					<asp:ListItem Text="English - New Zealand" Value="en-NZ" />
					<asp:ListItem Text="English - Philippines" Value="en-PH" />
					<asp:ListItem Text="English - South Africa" Value="en-ZA" />
					<asp:ListItem Text="English - Trinidad and Tobago" Value="en-TT" />
					<asp:ListItem Text="English - United Kingdom" Value="en-GB" />
					<asp:ListItem Text="English - United States" Value="en-US" />
					<asp:ListItem Text="English - Zimbabwe" Value="en-ZW" />
					<asp:ListItem Text="Estonian" Value="et" />
					<asp:ListItem Text="Estonian - Estonia" Value="et-EE" />
					<asp:ListItem Text="Faroese" Value="fo" />
					<asp:ListItem Text="Faroese - Faroe Islands" Value="fo-FO" />
					<asp:ListItem Text="Farsi" Value="fa" />
					<asp:ListItem Text="Farsi - Iran" Value="fa-IR" />
					<asp:ListItem Text="Finnish" Value="fi" />
					<asp:ListItem Text="Finnish - Finland" Value="fi-FI" />
					<asp:ListItem Text="French" Value="fr" />
					<asp:ListItem Text="French - Belgium" Value="fr-BE" />
					<asp:ListItem Text="French - Canada" Value="fr-CA" />
					<asp:ListItem Text="French - France" Value="fr-FR" />
					<asp:ListItem Text="French - Luxembourg" Value="fr-LU" />
					<asp:ListItem Text="French - Monaco" Value="fr-MC" />
					<asp:ListItem Text="French - Switzerland" Value="fr-CH" />
					<asp:ListItem Text="Galician" Value="gl" />
					<asp:ListItem Text="Galician - Galician" Value="gl-ES" />
					<asp:ListItem Text="Georgian" Value="ka" />
					<asp:ListItem Text="Georgian - Georgia" Value="ka-GE" />
					<asp:ListItem Text="German" Value="de" />
					<asp:ListItem Text="German - Austria" Value="de-AT" />
					<asp:ListItem Text="German - Germany" Value="de-DE" />
					<asp:ListItem Text="German - Liechtenstein" Value="de-LI" />
					<asp:ListItem Text="German - Luxembourg" Value="de-LU" />
					<asp:ListItem Text="German - Switzerland" Value="de-CH" />
					<asp:ListItem Text="Greek" Value="el" />
					<asp:ListItem Text="Greek - Greece" Value="el-GR" />
					<asp:ListItem Text="Gujarati" Value="gu" />
					<asp:ListItem Text="Gujarati - India" Value="gu-IN" />
					<asp:ListItem Text="Hebrew" Value="he" />
					<asp:ListItem Text="Hebrew - Israel" Value="he-IL" />
					<asp:ListItem Text="Hindi" Value="hi" />
					<asp:ListItem Text="Hindi - India" Value="hi-IN" />
					<asp:ListItem Text="Hungarian" Value="hu" />
					<asp:ListItem Text="Hungarian - Hungary" Value="hu-HU" />
					<asp:ListItem Text="Icelandic" Value="is" />
					<asp:ListItem Text="Icelandic - Iceland" Value="is-IS" />
					<asp:ListItem Text="Indonesian" Value="id" />
					<asp:ListItem Text="Indonesian - Indonesia" Value="id-ID" />
					<asp:ListItem Text="Italian" Value="it" />
					<asp:ListItem Text="Italian - Italy" Value="it-IT" />
					<asp:ListItem Text="Italian - Switzerland" Value="it-CH" />
					<asp:ListItem Text="Japanese" Value="ja" />
					<asp:ListItem Text="Japanese - Japan" Value="ja-JP" />
					<asp:ListItem Text="Kannada" Value="kn" />
					<asp:ListItem Text="Kannada - India" Value="kn-IN" />
					<asp:ListItem Text="Kazakh" Value="kk" />
					<asp:ListItem Text="Kazakh - Kazakhstan" Value="kk-KZ" />
					<asp:ListItem Text="Konkani" Value="kok" />
					<asp:ListItem Text="Konkani - India" Value="kok-IN" />
					<asp:ListItem Text="Korean" Value="ko" />
					<asp:ListItem Text="Korean - Korea" Value="ko-KR" />
					<asp:ListItem Text="Kyrgyz" Value="ky" />
					<asp:ListItem Text="Kyrgyz - Kazakhstan" Value="ky-KZ" />
					<asp:ListItem Text="Latvian" Value="lv" />
					<asp:ListItem Text="Latvian - Latvia" Value="lv-LV" />
					<asp:ListItem Text="Lithuanian" Value="lt" />
					<asp:ListItem Text="Lithuanian - Lithuania" Value="lt-LT" />
					<asp:ListItem Text="Macedonian" Value="mk" />
					<asp:ListItem Text="Macedonian - FYROM" Value="mk-MK" />
					<asp:ListItem Text="Malay" Value="ms" />
					<asp:ListItem Text="Malay - Brunei" Value="ms-BN" />
					<asp:ListItem Text="Malay - Malaysia" Value="ms-MY" />
					<asp:ListItem Text="Marathi" Value="mr" />
					<asp:ListItem Text="Marathi - India" Value="mr-IN" />
					<asp:ListItem Text="Mongolian" Value="mn" />
					<asp:ListItem Text="Mongolian - Mongolia" Value="mn-MN" />
					<asp:ListItem Text="Norwegian" Value="no" />
					<asp:ListItem Text="Norwegian (Bokm�l) - Norway" Value="nb-NO" />
					<asp:ListItem Text="Norwegian (Nynorsk) - Norway" Value="nn-NO" />
					<asp:ListItem Text="Polish" Value="pl" />
					<asp:ListItem Text="Polish - Poland" Value="pl-PL" />
					<asp:ListItem Text="Portuguese" Value="pt" />
					<asp:ListItem Text="Portuguese - Brazil" Value="pt-BR" />
					<asp:ListItem Text="Portuguese - Portugal" Value="pt-PT" />
					<asp:ListItem Text="Punjabi" Value="pa" />
					<asp:ListItem Text="Punjabi - India" Value="pa-IN" />
					<asp:ListItem Text="Romanian" Value="ro" />
					<asp:ListItem Text="Romanian - Romania" Value="ro-RO" />
					<asp:ListItem Text="Russian" Value="ru" />
					<asp:ListItem Text="Russian - Russia" Value="ru-RU" />
					<asp:ListItem Text="Sanskrit" Value="sa" />
					<asp:ListItem Text="Sanskrit - India" Value="sa-IN" />
					<asp:ListItem Text="Serbian (Cyrillic) - Serbia" Value="Cy-sr-SP" />
					<asp:ListItem Text="Serbian (Latin) - Serbia" Value="Lt-sr-SP" />
					<asp:ListItem Text="Slovak" Value="sk" />
					<asp:ListItem Text="Slovak - Slovakia" Value="sk-SK" />
					<asp:ListItem Text="Slovenian" Value="sl" />
					<asp:ListItem Text="Slovenian - Slovenia" Value="sl-SI" />
					<asp:ListItem Text="Spanish" Value="es" />
					<asp:ListItem Text="Spanish - Argentina" Value="es-AR" />
					<asp:ListItem Text="Spanish - Bolivia" Value="es-BO" />
					<asp:ListItem Text="Spanish - Chile" Value="es-CL" />
					<asp:ListItem Text="Spanish - Colombia" Value="es-CO" />
					<asp:ListItem Text="Spanish - Costa Rica" Value="es-CR" />
					<asp:ListItem Text="Spanish - Dominican Republic" Value="es-DO" />
					<asp:ListItem Text="Spanish - Ecuador" Value="es-EC" />
					<asp:ListItem Text="Spanish - El Salvador" Value="es-SV" />
					<asp:ListItem Text="Spanish - Guatemala" Value="es-GT" />
					<asp:ListItem Text="Spanish - Honduras" Value="es-HN" />
					<asp:ListItem Text="Spanish - Mexico" Value="es-MX" />
					<asp:ListItem Text="Spanish - Nicaragua" Value="es-NI" />
					<asp:ListItem Text="Spanish - Panama" Value="es-PA" />
					<asp:ListItem Text="Spanish - Paraguay" Value="es-PY" />
					<asp:ListItem Text="Spanish - Peru" Value="es-PE" />
					<asp:ListItem Text="Spanish - Puerto Rico" Value="es-PR" />
					<asp:ListItem Text="Spanish - Spain" Value="es-ES" />
					<asp:ListItem Text="Spanish - Uruguay" Value="es-UY" />
					<asp:ListItem Text="Spanish - Venezuela" Value="es-VE" />
					<asp:ListItem Text="Swahili" Value="sw" />
					<asp:ListItem Text="Swahili - Kenya" Value="sw-KE" />
					<asp:ListItem Text="Swedish" Value="sv" />
					<asp:ListItem Text="Swedish - Finland" Value="sv-FI" />
					<asp:ListItem Text="Swedish - Sweden" Value="sv-SE" />
					<asp:ListItem Text="Syriac" Value="syr" />
					<asp:ListItem Text="Syriac - Syria" Value="syr-SY" />
					<asp:ListItem Text="Tamil" Value="ta" />
					<asp:ListItem Text="Tamil - India" Value="ta-IN" />
					<asp:ListItem Text="Tatar" Value="tt" />
					<asp:ListItem Text="Tatar - Russia" Value="tt-RU" />
					<asp:ListItem Text="Telugu" Value="te" />
					<asp:ListItem Text="Telugu - India" Value="te-IN" />
					<asp:ListItem Text="Thai" Value="th" />
					<asp:ListItem Text="Thai - Thailand" Value="th-TH" />
					<asp:ListItem Text="Turkish" Value="tr" />
					<asp:ListItem Text="Turkish - Turkey" Value="tr-TR" />
					<asp:ListItem Text="Ukrainian" Value="uk" />
					<asp:ListItem Text="Ukrainian - Ukraine" Value="uk-UA" />
					<asp:ListItem Text="Urdu" Value="ur" />
					<asp:ListItem Text="Urdu - Pakistan" Value="ur-PK" />
					<asp:ListItem Text="Uzbek" Value="uz" />
					<asp:ListItem Text="Uzbek (Cyrillic) - Uzbekistan" Value="Cy-uz-UZ" />
					<asp:ListItem Text="Uzbek (Latin) - Uzbekistan" Value="Lt-uz-UZ" />
					<asp:ListItem Text="Vietnamese" Value="vi" />
					<asp:ListItem Text="Vietnamese - Vietnam" Value="vi-VN" />
				</asp:DropDownList>
			</p>
		</fieldset>
		<fieldset class="options">
			<legend>Count Settings</legend>
			<p>
				<label class="Block" accesskey="d" for="Edit_ddlItemCount"><u>D</u>efault Number of Feed/Homepage Items</label>
				<asp:DropDownList id="ddlItemCount" runat="server"></asp:DropDownList>
			</p>
			<p>
				<label class="Block" accesskey="p" for="Edit_ddlCategoryListPostCount">Number of <u>P</u>osts in Category Lists</label>
				<asp:DropDownList id="ddlCategoryListPostCount" runat="server"></asp:DropDownList>
			</p>
		</fieldset>
		<div class="clear">
			<div class="options">
				<p>
					<label class="Block" accesskey="c" for="Edit_txbSecondaryCss">
					<st:HelpToolTip id="HelpToolTip1" runat="server" HelpText="You can enter custom CSS within this block.  Be careful as the tool will not validate the CSS.  This CSS will be included (as a proper link) within every page of your blog."><u>C</u>ustom CSS</st:HelpToolTip>
					</label>
					<asp:TextBox id="txbSecondaryCss" runat="server" CssClass="textarea" TextMode="MultiLine"></asp:TextBox>
				</p>
			</div>
			<div class="options">
				<p>
					<label class="Block" accesskey="a" for="Edit_txbNews">Static News/<u>A</u>nnouncement</label>
					<asp:TextBox id="txbNews" runat="server" CssClass="textarea" TextMode="MultiLine"></asp:TextBox>
				</p>
			</div>
		</div>
		<div class="clear">
			<asp:Button id="btnPost" runat="server" CssClass="buttonSubmit" Text="Save" />
		</div>
	</st:AdvancedPanel>
</asp:Content>
