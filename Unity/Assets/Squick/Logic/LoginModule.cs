using System;
using System.Linq;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using SquickStruct;
using UnityEngine;
using Squick;
using Google.Protobuf;
using System.Globalization;

namespace Squick
{
    public class LoginModule : IModule
    {
        public enum Event : int
        {
            StartToConnect = 0,
            Connected,
            Disconnected,
            ConnectionRefused,

            RoleList = 10,
            LoginSuccess,
            LoginFailure,
            EnterLobbySuccess,
            EnterLobbyFailure,
        };


        public string mAccount;
        public string mKey;
        public int mServerID;
        public static int autoReconnectGameID = 0;
        public Guid mRoleID = new Guid();
        public string mRoleName;

        private MemoryStream mxBody = new MemoryStream();

        private NetModule mNetModule;
        private ISEventModule mEventModule;
        private IKernelModule mKernelModule;
        private HelpModule mHelpModule;

        public LoginModule(IPluginManager pluginManager)
        {
            mPluginManager = pluginManager;
        }

        public override void Awake()
        {
            mNetModule = mPluginManager.FindModule<NetModule>();
            mEventModule = mPluginManager.FindModule<ISEventModule>();
            mKernelModule = mPluginManager.FindModule<IKernelModule>();
            mHelpModule = mPluginManager.FindModule<HelpModule>();
        }

        public override void Start()
        {
            mNetModule.AddReceiveCallBack((int)SquickStruct.ProxyRPC.AckLogin, OnAckLogin);
            mNetModule.AddReceiveCallBack((int)SquickStruct.GameLobbyRPC.AckEnter, OnAckEnter);
            mEventModule.RegisterCallback((int)LoginModule.Event.Connected, OnConnected);
            mEventModule.RegisterCallback((int)LoginModule.Event.Disconnected, OnDisconnected);
        }

        public override void AfterStart()
        {

        }

        public override void Update()
        {
        }

        public override void BeforeDestroy()
        {
        }

        public override void Destroy()
        {
        }

        public void OnConnected(int eventId, DataList valueList)
        {
            if (mKey != null && mKey.Length > 0)
            {
                //verify token, 连接成功，直接验证key
                OnReqLogin(mAccount, mKey);
            }
        }

        public void OnDisconnected(int eventId, DataList valueList)
        {
            Debug.Log("断开连接");
            if (mKey != null)
            {
                //reconnect
                mAccount = "";
                mKey = "";
                mServerID = 0;
                mRoleID = new Guid();
                mRoleName = "";


                DataList xDataList = mKernelModule.GetObjectList();
                for (int i = 0; i < xDataList.Count(); ++i)
                {
                    mKernelModule.DestroyObject(xDataList.ObjectVal(i));
                }
            }
        }

        public void OnReqLogin(string account, string password)
        {
            Debug.Log("请求登录中: acc: " + account + " pas: " + password);
            SquickStruct.ReqLogin xData = new SquickStruct.ReqLogin();
            xData.Account = ByteString.CopyFromUtf8(account);
            xData.Password = ByteString.CopyFromUtf8(password);
            xData.Token = ByteString.CopyFromUtf8("token");

            mxBody.SetLength(0);
            xData.WriteTo(mxBody);


            mAccount = account;
            mKey = password;


            mNetModule.SendMsg((int)SquickStruct.ProxyRPC.ReqLogin, mxBody);
        }

        public void OnReqEnter()
        {
            SquickStruct.AckEnter xData = new SquickStruct.AckEnter();
            mxBody.SetLength(0);
            xData.WriteTo(mxBody);
            mNetModule.SendMsg((int)SquickStruct.GameLobbyRPC.ReqEnter, mxBody);
        }

        private void OnAckEnter(int id, MemoryStream stream)
        {
            SquickStruct.MsgBase xMsg = SquickStruct.MsgBase.Parser.ParseFrom(stream);
            SquickStruct.AckEnter xData = SquickStruct.AckEnter.Parser.ParseFrom(xMsg.MsgData);

            if (xData.Code == 0)
            {
                Debug.Log("进入游戏成功");
                mEventModule.DoEvent((int)LoginModule.Event.EnterLobbySuccess);
            }
            else {
                Debug.Log("进入游戏失败" + xData.Code);
                mEventModule.DoEvent((int)LoginModule.Event.EnterLobbyFailure);
            }
        }

        // 接收消息
        private void OnAckLogin(int id, MemoryStream stream)
        {
            SquickStruct.MsgBase xMsg = SquickStruct.MsgBase.Parser.ParseFrom(stream);
            SquickStruct.AckLogin xData = SquickStruct.AckLogin.Parser.ParseFrom(xMsg.MsgData);

            if (xData.Code == 0)
            {
                Debug.Log("Login  SUCCESS");
                mEventModule.DoEvent((int)LoginModule.Event.LoginSuccess);
            }
            else
            {
                Debug.Log("Login Faild,Code: " + xData.Code);
                mEventModule.DoEvent((int)LoginModule.Event.LoginFailure);
            }
        }

    }
}