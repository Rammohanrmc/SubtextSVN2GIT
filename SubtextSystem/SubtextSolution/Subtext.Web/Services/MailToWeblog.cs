#region Copyright (c) 2003, newtelligence AG. All rights reserved.

/*
// Copyright (c) 2003, newtelligence AG. (http://www.newtelligence.com)
// Original BlogX Source Code: Copyright (c) 2003, Chris Anderson (http://simplegeek.com)
// All rights reserved.
//  
// Redistribution and use in source and binary forms, with or without modification, are permitted 
// provided that the following conditions are met: 
//  
// (1) Redistributions of source code must retain the above copyright notice, this list of 
// conditions and the following disclaimer. 
// (2) Redistributions in binary form must reproduce the above copyright notice, this list of 
// conditions and the following disclaimer in the documentation and/or other materials 
// provided with the distribution. 
// (3) Neither the name of the newtelligence AG nor the names of its contributors may be used 
// to endorse or promote products derived from this software without specific prior 
// written permission.
//      
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS 
// OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER 
// IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT 
// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// -------------------------------------------------------------------------
//
// Original BlogX source code (c) 2003 by Chris Anderson (http://simplegeek.com)
// 
// newtelligence is a registered trademark of newtelligence Aktiengesellschaft.
// 
// For portions of this software, the some additional copyright notices may apply 
// which can either be found in the license.txt file included in the source distribution
// or following this notice. 
//
*/

#endregion

#region Disclaimer/Info

///////////////////////////////////////////////////////////////////////////////////////////////////
// .Text WebLog
// 
// .Text is an open source weblog system started by Scott Watermasysk. 
// Blog: http://ScottWater.com/blog 
// RSS: http://scottwater.com/blog/rss.aspx
// Email: Dottext@ScottWater.com
//
// For updated news and information please visit http://scottwater.com/dottext and subscribe to 
// the Rss feed @ http://scottwater.com/dottext/rss.aspx
//
// On its release (on or about August 1, 2003) this application is licensed under the BSD. However, I reserve the 
// right to change or modify this at any time. The most recent and up to date license can always be fount at:
// http://ScottWater.com/License.txt
// 
// Please direct all code related questions to:
// GotDotNet Workspace: http://www.gotdotnet.com/Community/Workspaces/workspace.aspx?id=e99fccb3-1a8c-42b5-90ee-348f6b77c407
// Yahoo Group http://groups.yahoo.com/group/DotText/
// 
///////////////////////////////////////////////////////////////////////////////////////////////////

#endregion

 /*Gurkan Yeniceri
This code is heavily relying on DasBlog's MailToWebLog function.
Modificatios made by Gurkan Yeniceri and implemented for SubText.
For the MailToWebLog feature to function properly, here are the changes and things that you need to do.

 **FILE(S) CHANGED**
1-Global.asax.cs
2-BlogInfo.cs
3-Configure.aspx
4-Configure.aspx.cs
5-DataHelper.cs
6-SqlDataProvider.cs
7-web.config
8-Subtext.DotTextUpgrader/Scripts/Installation.01.00.00.sql
9-Subtext.DotTextUpgrader/Scripts/StoredProcedures.sql
10-Subtext.Installation/Scripts/Installation.01.00.00.sql
11-Subtext.Installation/Scripts/StoredProcedures.sql

**FILE(S) ADDED**
1-MailToWebLog.cs
2-Lesnikowski.Pawel.Mail.Pop3.dll (Under External Dependencies folder)

**STORED PROCEDURE(S) CHANGED**
1-subtext_GetBlogById
2-subtext_GetBlogsByHost
3-subtext_GetConfig
4-subtext_GetPageableBlogs
5-subtext_UpdateConfig

**TABLE(S) CHANGED**
1-subtext_Config

**FOLDER(S) SETTINGS CHANGED**
1-"Image" folder needs write access by the aspnet user (also Network Services user if it is on Win2003 Server). On a hosted 
web site, you need to arrange write access through your management console.

**PROBLEM(S)**
1-How can I secure the "Image" folder from browsing?
2-Do not send an e-mail with a subject that is already used as a title for an entry before. -This type of e-mail will not be published
3-What if the image file name in the e-mail is already existing in the Image folder? - Check StoreAttachment function
4-What if the message is containing a zip attachment? - Currently it will not publish that e-mail

**SUGGESTION(S)**
1- Mail To Weblog thread interval: Shall we keep it in web.config?
2-Zip attachment feature. publish the e-mail and give a link to zip file.
3-Categories are dropped in this release. User can select categories in square brackets in a semi colon seperated list like [CSharp;DotNet] on the subject of the e-mail

**MANDATORY**
1- AggregateHost in web.config should be set to a correct value and no "http://" in the beginning.
2- AggregateUrl must be set to a correct value to identify the root SubText installation.
3-ThreadSleep may be changed, the default is 30 mins.

**HOW IT WORKS**
Mail to Weblog runs on a different thread. A simple flow is:
1-Get active blogs
2-Get blog's pop3 parameters
3-Connect to pop3 and process e-mails
4-Continue with the next blog
5-If all blogs are processed then sleep
6-Wake up and continue from step 1

*/

namespace Subtext.Web.Services
{
	using System;
	using System.Collections;
	using System.Configuration;
	using System.Data;
	using System.Data.SqlClient;
	using System.Drawing;
	using System.Drawing.Imaging;
	using System.IO;
	using System.Text.RegularExpressions;
	using System.Threading;
	using System.Web;
	using Lesnikowski.Pawel.Mail.Pop3;

	/// <summary>
	/// This is the handler class for the Mail-To-Weblog functionality.
	/// </summary>
	public class MailToWeblog
	{
		string binariesPath = HttpContext.Current.Server.MapPath("~/Images/"); //give write access for aspnet user (+Network Services user on win2003 server)

		Uri binariesBaseUri = new Uri(string.Concat(ConfigurationSettings.AppSettings.Get("AggregateUrl"), "/Images"));

		Framework.Components.Entry entry = new Framework.Components.Entry(Extensibility.PostType.BlogPost);

		/// <summary>
		/// Mail-To-Weblog runs in background thread and this is the thread function.
		/// Check Global.asax for the thread thingy
		/// </summary>
		public void Run()
		{
			//To go through the Blogs in subtext_config table
			//TODO: We may have multiple domains and multiple blogs for each domain.
			//This method won't work if this is the case
			Framework.Components.BlogInfoCollection activeBlogs = new Framework.Components.BlogInfoCollection();
			string host = ConfigurationSettings.AppSettings.Get("AggregateHost"); //it is important to set up the AggregateHost in web.config
			activeBlogs = Framework.BlogInfo.GetBlogsByHost(host); //get the active blogs !!! IS THERE A BETTER WAY WITHOUT USING AGGREGATEHOST???

			//this is the main loop where all the blogs are checked
			//TODO: Interval to check the blogs will be read from the web.config
			foreach (Framework.BlogInfo activeblog in activeBlogs)
			{
				//for the email stripping
				//because of if statements
				//this declarion had to be moved here
				Regex bodyExtractor;

				#region mail check loop

				//do
				//{
				try
				{
					//for trace, delete later
					int ret = activeblog.BlogID;

					//check if necessary properties are set
					if (activeblog.pop3MTBEnable &&
						activeblog.pop3Server != null && activeblog.pop3Server.Length > 0 &&
						activeblog.pop3User != null && activeblog.pop3User.Length > 0)
					{
						Pop3 pop3 = new Pop3();

						try
						{
							pop3.host = activeblog.pop3Server;
							pop3.userName = activeblog.pop3User;
							pop3.password = activeblog.pop3Pass;

							pop3.Connect();
							pop3.Login();
							pop3.GetAccountStat();

							for (int j = pop3.messageCount; j >= 1; j--)
							{
								#region for loop for the messages

								Pop3Message message = pop3.GetMessage(j);

								string messageFrom;
								// luke@jurasource.co.uk 1-MAR-04
								// only delete those messages that are processed
								bool messageWasProcessed = false;

								// E-Mail addresses look usually like this:
								// My Name <myname@example.com> or simply
								// myname@example.com. This block handles 
								// both variants.
								Regex getEmail = new Regex(".*\\<(?<email>.*?)\\>.*");
								Match matchEmail = getEmail.Match(message.from);
								if (matchEmail.Success)
								{
									messageFrom = matchEmail.Groups["email"].Value;
								}
								else
								{
									messageFrom = message.from;
								}

								// Only if the subject of the message is prefixed (case-sensitive) with
								// the configured subject prefix, we accept the message
								if (message.subject.StartsWith(activeblog.pop3SubjectPrefix))
								{
									//Prepare the entry 
									entry.Title = message.subject.Substring(activeblog.pop3SubjectPrefix.Length);
									entry.BlogID = activeblog.BlogID;
									entry.DisplayOnHomePage = true;
									entry.Body = "";
									entry.Author = activeblog.Author;
									entry.AllowComments = true;
									entry.SyndicateDescriptionOnly = false;
									entry.IsAggregated = true;
									entry.EntryName = string.Empty;
									entry.IncludeInMainSyndication = true;
									entry.IsActive = true;
									entry.DateSyndicated = DateTime.Now;

									//TODO: Change this to DateTime.Now if it doesn't work properly
									//entry.DateCreated = DateTime.Parse(message.date); //may not be best date
									entry.DateCreated = DateTime.Now;

									//UNNECESSARY PROPERTIES, maybe we will need them later
									//entry.SourceUrl = string.Empty;
									//entry.Description = string.Empty;
									//entry.TitleUrl = string.Empty;
									//entry.SourceName = string.Empty;
									//entry.ParentID = NullValue.NullInt32;

									// Grab the categories. Categories are defined in square brackets 
									// in the subject line.
									//TODO: not implemented yet
									Regex categoriesRegex = new Regex("(?<exp>\\[(?<cat>.*?)\\])");
									foreach (Match match in categoriesRegex.Matches(entry.Title))
									{
										entry.Title = entry.Title.Replace(match.Groups["exp"].Value, "");
										//entry.Categories += match.Groups["cat"].Value+";";
									}
									entry.Title = entry.Title.Trim();

									//TODO: Categories will be added later
									//string categories = "";
									//                                    string[] splitted = entry.Categories.Split(';');
									//                                    for( int i=0;i<splitted.Length;i++)
									//                                    {
									//                                        categories += splitted[i].Trim()+";";
									//                                    }
									//entry.Categories = categories.TrimEnd(';');

									//entry.DateCreated = RFC2822Date.Parse(message.date);

									#region Plain Text

									if (message.contentType.StartsWith("text/plain"))
									{
										entry.Body += message.body;
									}
										#endregion

										#region Just HTML
										// Luke Latimer 16-FEB-2004 (luke@jurasource.co.uk)
										// HTML only emails were not appearing
									else if (message.contentType.StartsWith("text/html"))
									{
										string messageText = "";

										// Note the email may still be encoded
										//messageText = QuotedCoding.DecodeOne(message.charset, "Q", message.body);										
										messageText = message.body;

										/*
											* CHANGE: I have changed the e-mail content sripping
											* to not to include message disclaimer on the blog entry
											*/
										// Strip the <body> out of the message (using code from below)
										if (activeblog.pop3StartTag == string.Empty)
											bodyExtractor = new Regex("<body.*?>(?<content>.*)</body>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
										else
											bodyExtractor = new Regex(activeblog.pop3StartTag + "(?<content>.*)" + activeblog.pop3EndTag, RegexOptions.IgnoreCase | RegexOptions.Singleline);

										Match match = bodyExtractor.Match(messageText);
										if (match != null && match.Success && match.Groups["content"] != null)
										{
											entry.Body += match.Groups["content"].Value;
										}
										else
										{
											entry.Body += messageText;
										}

									}
										#endregion
					
										// HTML/Text with attachments ?
									else if (
										message.contentType.StartsWith("multipart/alternative") ||
											message.contentType.StartsWith("multipart/related") ||
											message.contentType.StartsWith("multipart/mixed"))
									{
										Hashtable embeddedFiles = new Hashtable();
										ArrayList attachedFiles = new ArrayList();

										foreach (Attachment attachment in message.attachments)
										{
											// just plain text?
											if (attachment.contentType.StartsWith("text/plain"))
											{
												entry.Body += StringOperations.GetString(attachment.data);
											}

												// Luke Latimer 16-FEB-2004 (luke@jurasource.co.uk)
												// Allow for html-only attachments
											else if (attachment.contentType.StartsWith("text/html"))
											{
												/*
													* CHANGE: I have changed the e-mail content sripping
													* to not to include message disclaimer on the blog entry
													* */
												// Strip the <body> out of the message (using code from below)		
												if (activeblog.pop3StartTag == string.Empty)
													bodyExtractor = new Regex("<body.*?>(?<content>.*)</body>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
												else
													bodyExtractor = new Regex(activeblog.pop3StartTag + "(?<content>.*)" + activeblog.pop3EndTag, RegexOptions.IgnoreCase | RegexOptions.Singleline);

												string htmlString = StringOperations.GetString(attachment.data);
												Match match = bodyExtractor.Match(htmlString);

												//NOTE: We will BLOW AWAY any previous content in this case.
												// This is because most mail clients like Outlook include
												// plain, then HTML. We will grab plain, then blow it away if 
												// HTML is included later.
												if (match != null && match.Success && match.Groups["content"] != null)
												{
													entry.Body = match.Groups["content"].Value;
												}
												else
												{
													entry.Body = htmlString;
												}
											}			

												// or alternative text ?
											else if (attachment.contentType.StartsWith("multipart/alternative"))
											{
												bool contentSet = false;
												string textContent = null;
												foreach (Attachment inner_attachment in attachment.attachments)
												{
													// we prefer HTML
													if (inner_attachment.contentType.StartsWith("text/plain"))
													{
														textContent = StringOperations.GetString(inner_attachment.data);
													}
													else if (inner_attachment.contentType.StartsWith("text/html"))
													{
														/*
															* CHANGE: I have changed the e-mail content sripping
															* to not to include message disclaimer on the blog entry
															*/
														if (activeblog.pop3StartTag == string.Empty)
															bodyExtractor = new Regex("<body.*?>(?<content>.*)</body>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
														else
															bodyExtractor = new Regex(activeblog.pop3StartTag + "(?<content>.*)" + activeblog.pop3EndTag, RegexOptions.IgnoreCase | RegexOptions.Singleline);

														string htmlString = StringOperations.GetString(inner_attachment.data);
														Match match = bodyExtractor.Match(htmlString);
														if (match != null && match.Success && match.Groups["content"] != null)
														{
															entry.Body += match.Groups["content"].Value;
														}
														else
														{
															entry.Body += htmlString;
														}
														contentSet = true;
													}
												}
												if (!contentSet)
												{
													entry.Body += textContent;
												}
											}
												// or text with embeddedFiles (in a mixed message only)
											else if ((message.contentType.StartsWith("multipart/mixed") || message.contentType.StartsWith("multipart/alternative"))
												&& attachment.contentType.StartsWith("multipart/related"))
											{
												foreach (Attachment inner_attachment in attachment.attachments)
												{
													// just plain text?
													if (inner_attachment.contentType.StartsWith("text/plain"))
													{
														entry.Body += StringOperations.GetString(inner_attachment.data);
													}

													else if (inner_attachment.contentType.StartsWith("text/html"))
													{
														/*
															* CHANGE: I have changed the e-mail content sripping
															* to not to include message disclaimer on the blog entry
															*/
														if (activeblog.pop3StartTag == string.Empty)
															bodyExtractor = new Regex("<body.*?>(?<content>.*)</body>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
														else
															bodyExtractor = new Regex(activeblog.pop3StartTag + "(?<content>.*)" + activeblog.pop3EndTag, RegexOptions.IgnoreCase | RegexOptions.Singleline);

														string htmlString = StringOperations.GetString(inner_attachment.data);
														Match match = bodyExtractor.Match(htmlString);
														if (match != null && match.Success && match.Groups["content"] != null)
														{
															entry.Body += match.Groups["content"].Value;
														}
														else
														{
															entry.Body += htmlString;
														}
													}
		   													
														// or alternative text ?
													else if (inner_attachment.contentType.StartsWith("multipart/alternative"))
													{
														bool contentSet = false;
														string textContent = null;
														foreach (Attachment inner_inner_attachment in inner_attachment.attachments)
														{
															// we prefer HTML
															if (inner_inner_attachment.contentType.StartsWith("text/plain"))
															{
																textContent = StringOperations.GetString(inner_inner_attachment.data);
															}
															else if (inner_inner_attachment.contentType.StartsWith("text/html"))
															{
																/*
																	* CHANGE: I have changed the e-mail content sripping
																	* to not to include message disclaimer on the blog entry
																	*/
																if (activeblog.pop3StartTag == string.Empty)
																	bodyExtractor = new Regex("<body.*?>(?<content>.*)</body>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
																else
																	bodyExtractor = new Regex(activeblog.pop3StartTag + "(?<content>.*)" + activeblog.pop3EndTag, RegexOptions.IgnoreCase | RegexOptions.Singleline);

																string htmlString = StringOperations.GetString(inner_inner_attachment.data);
																Match match = bodyExtractor.Match(htmlString);
																if (match != null && match.Success && match.Groups["content"] != null)
																{
																	entry.Body += match.Groups["content"].Value;
																}
																else
																{
																	entry.Body += htmlString;
																}
																contentSet = true;
															}
														}
														if (!contentSet)
														{
															entry.Body += textContent;
														}
													}
														// any other inner_attachment
													else if (inner_attachment.data != null &&
														inner_attachment.fileName != null &&
														inner_attachment.fileName.Length > 0)
													{
														if (inner_attachment.contentID.Length > 0)
														{
															embeddedFiles.Add(inner_attachment.contentID, StoreAttachment(inner_attachment, binariesPath));
														}
														else
														{
															attachedFiles.Add(StoreAttachment(inner_attachment, binariesPath));
														}
													}
												}
											}
												// any other attachment
											else if (attachment.data != null &&
												attachment.fileName != null &&
												attachment.fileName.Length > 0)
											{
												if (attachment.contentID.Length > 0 && message.contentType.StartsWith("multipart/related"))
												{
													embeddedFiles.Add(attachment.contentID, StoreAttachment(attachment, binariesPath));
												}
												else
												{
													attachedFiles.Add(StoreAttachment(attachment, binariesPath));
												}

											}
										}

										// check for orphaned embeddings
										string[] embeddedKeys = new string[embeddedFiles.Keys.Count];
										embeddedFiles.Keys.CopyTo(embeddedKeys, 0);
										foreach (string key in embeddedKeys)
										{
											if (entry.Body.IndexOf("cid:" + key.Trim('<', '>')) == -1)
											{
												object file = embeddedFiles[key];
												embeddedFiles.Remove(key);
												attachedFiles.Add(file);
											}
										}

										// now fix up the URIs

										if (activeblog.pop3InlineAttachedPictures)
										{
											foreach (string fileName in attachedFiles)
											{
												string fileNameU = fileName.ToUpper();
												if (fileNameU.EndsWith(".JPG") || fileNameU.EndsWith(".JPEG") ||
													fileNameU.EndsWith(".GIF") || fileNameU.EndsWith(".PNG") ||
													fileNameU.EndsWith(".BMP"))
												{
													bool scalingSucceeded = false;

													if (activeblog.pop3HeightForThumbs > 0)
													{
														try
														{
															string absoluteFileName = Path.Combine(binariesPath, fileName);
															string thumbBaseFileName = Path.GetFileNameWithoutExtension(fileName) + "-thumb.dasblog.JPG";
															string thumbFileName = Path.Combine(binariesPath, thumbBaseFileName);
															Bitmap sourceBmp = new Bitmap(absoluteFileName);
															if (sourceBmp.Height > activeblog.pop3HeightForThumbs)
															{
																Bitmap targetBmp = new Bitmap(sourceBmp, new Size(
																	Convert.ToInt32(Math.Round((((double) sourceBmp.Width)*(((double) activeblog.pop3HeightForThumbs)/((double) sourceBmp.Height))), 0)),
																	activeblog.pop3HeightForThumbs));

																ImageCodecInfo codecInfo = GetEncoderInfo("image/jpeg");
																Encoder encoder = Encoder.Quality;
																EncoderParameters encoderParams = new EncoderParameters(1);
																long compression = 75;
																EncoderParameter encoderParam = new EncoderParameter(encoder, compression);
																encoderParams.Param[0] = encoderParam;
																targetBmp.Save(thumbFileName, codecInfo, encoderParams);

																string absoluteUri = new Uri(binariesBaseUri, fileName).AbsoluteUri;
																string absoluteThumbUri = new Uri(binariesBaseUri, thumbBaseFileName).AbsoluteUri;
																entry.Body += String.Format("<div class=\"inlinedMailPictureBox\"><a href=\"{0}\"><img border=\"0\" class=\"inlinedMailPicture\" src=\"{2}\"></a><br><a class=\"inlinedMailPictureLink\" href=\"{0}\">{1}</a></div>", absoluteUri, fileName, absoluteThumbUri);
																scalingSucceeded = true;

															}
														}
														catch
														{
														}
													}
													if (!scalingSucceeded)
													{
														string absoluteUri = new Uri(binariesBaseUri, fileName).AbsoluteUri;
														entry.Body += String.Format("<div class=\"inlinedMailPictureBox\"><img class=\"inlinedMailPicture\" src=\"{0}\"><br><a class=\"inlinedMailPictureLink\" href=\"{0}\">{1}</a></div>", absoluteUri, fileName);
													}
												}
											}
										}

										if (attachedFiles.Count > 0)
										{
											entry.Body += "<p>";
										}

										foreach (string fileName in attachedFiles)
										{
											string fileNameU = fileName.ToUpper();
											if (!activeblog.pop3InlineAttachedPictures ||
												(!fileNameU.EndsWith(".JPG") && !fileNameU.EndsWith(".JPEG") &&
													!fileNameU.EndsWith(".GIF") && !fileNameU.EndsWith(".PNG") &&
													!fileNameU.EndsWith(".BMP")))
											{
												string absoluteUri = new Uri(binariesBaseUri, fileName).AbsoluteUri;
												entry.Body += String.Format("Download: <a href=\"{0}\">{1}</a><br>", absoluteUri, fileName);
											}
										}
										if (attachedFiles.Count > 0)
										{
											entry.Body += "</p>";
										}

										foreach (string key in embeddedFiles.Keys)
										{
											//This was working a minute ago, but broken for some unknown reason
											//the "images" directory is missing at the end of the img src link. It is there actually?????? Puzzled
											//entry.Body = entry.Body.Replace("cid:"+key.Trim('<','>'), new Uri( binariesBaseUri, (string)embeddedFiles[key] ).AbsoluteUri );

											entry.Body = entry.Body.Replace("cid:" + key.Trim('<', '>'), binariesBaseUri.AbsoluteUri + "/" + embeddedFiles[key]);

										}
									}

									//everything is good, create the entry
									CreateEntry(entry);

									messageWasProcessed = true;
								}
								// luke@jurasource.co.uk (01-MAR-04)
								if (activeblog.pop3DeleteOnlyProcessed || messageWasProcessed)
								{
									pop3.DeleteMessage(j);
								}
							}
						}
						catch (Exception e)
						{
							throw e;
						}
						finally
						{
							pop3.Close();
						}
					}

					#endregion for loop for mails

					//either active blog is not setup for mail to weblog functionality or 
					//all the emails are processed for this blog; in both cases
					//continue with the next blog
					continue;
				}
				catch (Exception e)
				{
					throw e;
				}
				//TODO:Logging can be done here

				#endregion Main Mail check loop
			}
			//if all the blogs and e-mails are processed thread may sleep here
			//Sleep time comes from web.config
			Thread.Sleep(TimeSpan.FromSeconds(int.Parse(ConfigurationSettings.AppSettings.Get("ThreadSleep"))));
		}

		/// <summary>
		/// This function is used for inserting the mail content as entry to db
		/// </summary>
		/// <param name="mailEntry"></param>
		/// <returns></returns>
		private void CreateEntry(Framework.Components.Entry mailEntry)
		{
			string sql = "subtext_InsertEntry";
			string conn = Framework.Providers.DbProvider.Instance().ConnectionString;

			SqlParameter[] p =
				{
					Framework.Data.SqlHelper.MakeInParam("@Title", SqlDbType.NVarChar, 255, mailEntry.Title),
					//SqlHelper.MakeInParam("@TitleUrl", SqlDbType.NVarChar, 255, mailEntry.TitleUrl),
					Framework.Data.SqlHelper.MakeInParam("@Text", mailEntry.Body),
					//SqlHelper.MakeInParam("@SourceUrl", SqlDbType.NVarChar, 200, mailEntry.SourceUrl),
					Framework.Data.SqlHelper.MakeInParam("@PostType", SqlDbType.Int, 4, mailEntry.PostType),
					Framework.Data.SqlHelper.MakeInParam("@Author", SqlDbType.NVarChar, 50, mailEntry.Author),
					Framework.Data.SqlHelper.MakeInParam("@Email", SqlDbType.NVarChar, 50, mailEntry.Email),
					//SqlHelper.MakeInParam("@SourceName", SqlDbType.NVarChar, 200, mailEntry.SourceName),
					//SqlHelper.MakeInParam("@Description", SqlDbType.NVarChar, 500, mailEntry.Description),
					Framework.Data.SqlHelper.MakeInParam("@BlogId", SqlDbType.Int, 4, mailEntry.BlogID),
					Framework.Data.SqlHelper.MakeInParam("@DateAdded", mailEntry.DateCreated),
					//SqlHelper.MakeInParam("@ParentId", SqlDbType.Int, 4, mailEntry.ParentID),
					Framework.Data.SqlHelper.MakeInParam("@PostConfig", SqlDbType.Int, 4, 95),
					Framework.Data.SqlHelper.MakeInParam("@EntryName", SqlDbType.NVarChar, 150, mailEntry.Title),
					Framework.Data.SqlHelper.MakeInParam("@ContentCheckSumHash", SqlDbType.VarChar, 32, mailEntry.ContentChecksumHash),
					Framework.Data.SqlHelper.MakeInParam("@DateSyndicated", mailEntry.DateSyndicated),
					Framework.Data.SqlHelper.MakeOutParam("@ID", SqlDbType.Int, 4)
				};

			DataTable dt = Framework.Data.SqlHelper.ExecuteDataTable(conn, CommandType.StoredProcedure, sql, p);

			//Shall we dispose or leave it to GC
			//dt.Dispose();

		}


		/// <summary>
		/// Compares two binary buffers up to a certain length.
		/// </summary>
		/// <param name="buf1">First buffer</param>
		/// <param name="buf2">Second buffer</param>
		/// <param name="len">Length</param>
		/// <returns>true or false indicator about the equality of the buffers</returns>
		private bool EqualBuffers(byte[] buf1, byte[] buf2, int len)
		{
			if (buf1.Length >= len && buf2.Length >= len)
			{
				for (int l = 0; l < len; l++)
				{
					if (buf1[l] != buf2[l])
						return false;
				}
				return true;
			}
			return false;
		}


		/// <summary>
		/// Stores an attachment to disk.
		/// </summary>
		/// <param name="attachment"></param>
		/// <param name="binariesPath"></param>
		/// <returns></returns>
		public string StoreAttachment(Attachment attachment, string binariesPath)
		{
			bool alreadyUploaded = false;
			string baseFileName = attachment.fileName;
			string targetFileName = Path.Combine(binariesPath, baseFileName);
			int numSuffix = 1;

			// if the target filename already exists, we check whether we already 
			// have that file stored by comparing the first 2048 bytes of the incoming
			// date to the target file (creating a hash would be better, but this is 
			// "good enough" for the time being)
			while (File.Exists(targetFileName))
			{
				byte[] targetBuffer = new byte[Math.Min(2048, attachment.data.Length)];
				int targetBytesRead;

				using (FileStream targetFile = new FileStream(targetFileName, FileMode.Open, FileAccess.Read, FileShare.Read))
				{
					long numBytes = targetFile.Length;
					if (numBytes == (long) attachment.data.Length)
					{
						targetBytesRead = targetFile.Read(targetBuffer, 0, targetBuffer.Length);
						if (targetBytesRead == targetBuffer.Length)
						{
							if (EqualBuffers(targetBuffer, attachment.data, targetBuffer.Length))
							{
								alreadyUploaded = true;
							}
						}
					}
				}

				// If the file names are equal, but it's not considered the same file,
				// we append an incrementing numeric suffix to the file name and retry.
				if (!alreadyUploaded)
				{
					string ext = Path.GetExtension(baseFileName);
					string file = Path.GetFileNameWithoutExtension(baseFileName);
					string newFileName = file + (numSuffix++).ToString();
					baseFileName = newFileName + ext;
					targetFileName = Path.Combine(binariesPath, baseFileName);
				}
				else
				{
					break;
				}
			}

			// now we've got a unique file name or the file is already stored. If it's
			// not stored, write it to disk.
			if (!alreadyUploaded)
			{
				using (FileStream fileStream = new FileStream(targetFileName, FileMode.Create))
				{
					fileStream.Write(attachment.data, 0, attachment.data.Length);
					fileStream.Flush();
				}
			}
			return baseFileName;
		}


		/// <summary>
		/// This function is used for thumbnailing and gets an image encoder
		/// for a given mime type, such as image/jpeg
		/// </summary>
		/// <param name="mimeType"></param>
		/// <returns></returns>
		private ImageCodecInfo GetEncoderInfo(string mimeType)
		{
			ImageCodecInfo[] codecs = ImageCodecInfo.GetImageEncoders();
			foreach (ImageCodecInfo codec in codecs)
			{
				if (codec.MimeType == mimeType)
				{
					return codec;
				}
			}
			return null;
		}


	}
}