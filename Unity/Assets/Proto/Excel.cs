// -------------------------------------------------------------------------
//    @FileName         :    Excel.cs
//    @Author           :    I0gan
//    @Module           :    Excel
// -------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
namespace Excel
{
	public class DB
	{
		//Class name
		public static readonly String ThisName = "DB";
		// IObject
		public static readonly String CampID = "CampID";// object
		public static readonly String ClassName = "ClassName";// string
		public static readonly String ConfigID = "ConfigID";// string
		public static readonly String Connection = "Connection";// int
		public static readonly String Disable = "Disable";// int
		public static readonly String GMMoveTo = "GMMoveTo";// vector3
		public static readonly String GroupID = "GroupID";// int
		public static readonly String ID = "ID";// string
		public static readonly String MasterID = "MasterID";// object
		public static readonly String MoveTo = "MoveTo";// vector3
		public static readonly String Name = "Name";// string
		public static readonly String Position = "Position";// vector3
		public static readonly String SceneID = "SceneID";// int
		public static readonly String State = "State";// int
		// Property
		public static readonly String Auth = "Auth";// string
		public static readonly String IP = "IP";// string
		public static readonly String Port = "Port";// int
		public static readonly String PublicIP = "PublicIP";// string
		public static readonly String ServerID = "ServerID";// int
		// Record

	}
	public class Group
	{
		//Class name
		public static readonly String ThisName = "Group";
		// IObject
		public static readonly String CampID = "CampID";// object
		public static readonly String ClassName = "ClassName";// string
		public static readonly String ConfigID = "ConfigID";// string
		public static readonly String Connection = "Connection";// int
		public static readonly String Disable = "Disable";// int
		public static readonly String GMMoveTo = "GMMoveTo";// vector3
		public static readonly String GroupID = "GroupID";// int
		public static readonly String ID = "ID";// string
		public static readonly String MasterID = "MasterID";// object
		public static readonly String MoveTo = "MoveTo";// vector3
		public static readonly String Name = "Name";// string
		public static readonly String Position = "Position";// vector3
		public static readonly String SceneID = "SceneID";// int
		public static readonly String State = "State";// int
		// Property
		// Record

	}
	public class IObject
	{
		//Class name
		public static readonly String ThisName = "IObject";
		// Property
		public static readonly String CampID = "CampID";// object
		public static readonly String ClassName = "ClassName";// string
		public static readonly String ConfigID = "ConfigID";// string
		public static readonly String Connection = "Connection";// int
		public static readonly String Disable = "Disable";// int
		public static readonly String GMMoveTo = "GMMoveTo";// vector3
		public static readonly String GroupID = "GroupID";// int
		public static readonly String ID = "ID";// string
		public static readonly String MasterID = "MasterID";// object
		public static readonly String MoveTo = "MoveTo";// vector3
		public static readonly String Name = "Name";// string
		public static readonly String Position = "Position";// vector3
		public static readonly String SceneID = "SceneID";// int
		public static readonly String State = "State";// int
		// Record

	}
	public class Player
	{
		//Class name
		public static readonly String ThisName = "Player";
		// IObject
		public static readonly String CampID = "CampID";// object
		public static readonly String ClassName = "ClassName";// string
		public static readonly String ConfigID = "ConfigID";// string
		public static readonly String Connection = "Connection";// int
		public static readonly String Disable = "Disable";// int
		public static readonly String GMMoveTo = "GMMoveTo";// vector3
		public static readonly String GroupID = "GroupID";// int
		public static readonly String ID = "ID";// string
		public static readonly String MasterID = "MasterID";// object
		public static readonly String MoveTo = "MoveTo";// vector3
		public static readonly String Name = "Name";// string
		public static readonly String Position = "Position";// vector3
		public static readonly String SceneID = "SceneID";// int
		public static readonly String State = "State";// int
		// Property
		public static readonly String Account = "Account";// string
		public static readonly String BattlePoint = "BattlePoint";// int
		public static readonly String ClanID = "ClanID";// object
		public static readonly String ConnectKey = "ConnectKey";// string
		public static readonly String Diamond = "Diamond";// int
		public static readonly String EXP = "EXP";// int
		public static readonly String GMLevel = "GMLevel";// int
		public static readonly String GameID = "GameID";// int
		public static readonly String GateID = "GateID";// int
		public static readonly String Gold = "Gold";// int
		public static readonly String HP = "HP";// int
		public static readonly String Head = "Head";// string
		public static readonly String Job = "Job";// int
		public static readonly String LastOfflineTime = "LastOfflineTime";// object
		public static readonly String Level = "Level";// int
		public static readonly String MAXEXP = "MAXEXP";// int
		public static readonly String MP = "MP";// int
		public static readonly String NoticeID = "NoticeID";// int
		public static readonly String OnlineCount = "OnlineCount";// int
		public static readonly String OnlineTime = "OnlineTime";// object
		public static readonly String Race = "Race";// int
		public static readonly String ReconnectReason = "ReconnectReason";// int
		public static readonly String SP = "SP";// int
		public static readonly String ScenarioProgress = "ScenarioProgress";// int
		public static readonly String Sex = "Sex";// int
		public static readonly String SkillNormal = "SkillNormal";// string
		public static readonly String SkillSpecial1 = "SkillSpecial1";// string
		public static readonly String SkillSpecial2 = "SkillSpecial2";// string
		public static readonly String SkillTHUMP = "SkillTHUMP";// string
		public static readonly String TeamID = "TeamID";// object
		public static readonly String TotalTime = "TotalTime";// int
		// Record
		public class HeroEquipmentList
		{
			//Class name
			public static readonly String ThisName = "HeroEquipmentList";
			public const int HeroID = 0;//object
			public const int EquipmentID = 1;//object
			public const int SlotIndex = 2;//int

		}
		public class HeroList
		{
			//Class name
			public static readonly String ThisName = "HeroList";
			public const int GUID = 0;//object
			public const int ItemConfigID = 1;//string
			public const int ConfigID = 2;//string
			public const int Activated = 3;//int
			public const int Level = 4;//int
			public const int Exp = 5;//int
			public const int Star = 6;//int
			public const int HP = 7;//int

		}
		public class Inventory
		{
			//Class name
			public static readonly String ThisName = "Inventory";
			public const int ConfigID = 0;//string
			public const int ItemCount = 1;//int

		}
		public class InventoryEquipment
		{
			//Class name
			public static readonly String ThisName = "InventoryEquipment";
			public const int GUID = 0;//object
			public const int ConfigID = 1;//string
			public const int RandPropertyID = 2;//string
			public const int RandPropertyValue = 3;//int
			public const int IntensifyLevel = 4;//int
			public const int Date = 5;//int
			public const int Equipped = 6;//int
			public const int Stone1 = 7;//string
			public const int Stone2 = 8;//string
			public const int Stone3 = 9;//string
			public const int Stone4 = 10;//string
			public const int Lock = 11;//int
			public const int Future = 12;//int
			public const int UserData = 13;//string

		}

	}
	public class Scene
	{
		//Class name
		public static readonly String ThisName = "Scene";
		// IObject
		public static readonly String CampID = "CampID";// object
		public static readonly String ClassName = "ClassName";// string
		public static readonly String ConfigID = "ConfigID";// string
		public static readonly String Connection = "Connection";// int
		public static readonly String Disable = "Disable";// int
		public static readonly String GMMoveTo = "GMMoveTo";// vector3
		public static readonly String GroupID = "GroupID";// int
		public static readonly String ID = "ID";// string
		public static readonly String MasterID = "MasterID";// object
		public static readonly String MoveTo = "MoveTo";// vector3
		public static readonly String Name = "Name";// string
		public static readonly String Position = "Position";// vector3
		public static readonly String SceneID = "SceneID";// int
		public static readonly String State = "State";// int
		// Property
		public static readonly String ActorID = "ActorID";// int
		public static readonly String MaxGroup = "MaxGroup";// int
		public static readonly String MaxGroupPlayers = "MaxGroupPlayers";// int
		public static readonly String RelivePos = "RelivePos";// string
		public static readonly String RelivePosEx = "RelivePosEx";// string
		public static readonly String ResourcePos = "ResourcePos";// string
		public static readonly String SceneName = "SceneName";// string
		public static readonly String SceneShowName = "SceneShowName";// string
		public static readonly String SoundList = "SoundList";// string
		public static readonly String SubType = "SubType";// int
		public static readonly String Type = "Type";// int
		public static readonly String Width = "Width";// int
		// Record

	}
	public class Server
	{
		//Class name
		public static readonly String ThisName = "Server";
		// IObject
		public static readonly String CampID = "CampID";// object
		public static readonly String ClassName = "ClassName";// string
		public static readonly String ConfigID = "ConfigID";// string
		public static readonly String Connection = "Connection";// int
		public static readonly String Disable = "Disable";// int
		public static readonly String GMMoveTo = "GMMoveTo";// vector3
		public static readonly String GroupID = "GroupID";// int
		public static readonly String ID = "ID";// string
		public static readonly String MasterID = "MasterID";// object
		public static readonly String MoveTo = "MoveTo";// vector3
		public static readonly String Name = "Name";// string
		public static readonly String Position = "Position";// vector3
		public static readonly String SceneID = "SceneID";// int
		public static readonly String State = "State";// int
		// Property
		public static readonly String Area = "Area";// int
		public static readonly String CpuCount = "CpuCount";// int
		public static readonly String Exe = "Exe";// string
		public static readonly String IP = "IP";// string
		public static readonly String MaxOnline = "MaxOnline";// int
		public static readonly String Port = "Port";// int
		public static readonly String PublicIP = "PublicIP";// string
		public static readonly String ServerID = "ServerID";// int
		public static readonly String Type = "Type";// int
		public static readonly String UDPPort = "UDPPort";// int
		public static readonly String WSPort = "WSPort";// int
		public static readonly String WebPort = "WebPort";// int
		// Record

	}

}