<?php
phpinfo();

function show_line($line)
{
	echo "$line<br>\r\n";
}

function show_pre($info)
{
	echo "<pre>\r\n";
	echo htmlspecialchars($info);
	echo "\r\n</pre>\r\n";
}

$mi = new mediainfo();

var_dump($mi->isload);
if ($mi->isload)
{
	if (file_exists("example.ogg"))
	{
		show_line("Info_Version");
		$info = $mi->option("Info_Version","");
		show_pre($info);
		show_line("Info_Parameters");
		$info = $mi->option("Info_Parameters","");
		show_pre($info);
		show_line("Info_Capacities");
		$info = $mi->option("Info_Capacities","");
		show_pre($info);
		show_line("Info_Codecs");
		$info = $mi->option("Info_Codecs","");
		show_pre($info);
		var_dump($mi->open("D:\\wamp32\\www\\mediainfo\\Example.ogg"));
		var_dump($mi->mediafile);
		show_line("Inform with Complete=false");
		$mi->option("Complete","");
		//show_pre($info);
		show_pre($mi->get_inform(0));
		show_line("Inform with Complete=true");
		$mi->option("Complete","1");
		//show_pre($info);
		show_pre($mi->get_inform(0));		
		show_line("Custom Inform");
		$mi->option("Inform","'General;Example : FileSize=%FileSize%");
		//show_pre($info);
		show_pre($mi->get_inform(0));	

		show_line("GetI with Stream=General and Parameter:=17");
		show_pre($mi->get_i(MEDIAINFO_STREAM_GENERAL,0,17,MEDIAINFO_INFO_TEXT));
		
		show_line("Count_Get with StreamKind=Stream_Audio");
		show_pre($mi->get_count(MEDIAINFO_STREAM_AUDIO,-1));

		show_line("Get with Stream:=General and Parameter=^AudioCount^");
		show_pre($mi->get(MEDIAINFO_STREAM_GENERAL,0,"AudioCount",MEDIAINFO_INFO_TEXT,MEDIAINFO_INFO_NAME));

		show_line("Get with Stream:=Audio and Parameter=^StreamCount^");
		show_pre($mi->get(MEDIAINFO_STREAM_AUDIO,0,"StreamCount",MEDIAINFO_INFO_TEXT,MEDIAINFO_INFO_NAME));

		show_line("Get with Stream:=General and Parameter=^FileSize^");
		show_pre($mi->get(MEDIAINFO_STREAM_GENERAL,0,"FileSize",MEDIAINFO_INFO_TEXT,MEDIAINFO_INFO_NAME));
		
		show_line("Close");
		$mi->close();
	}
	
}
	
?>