using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.IO;
using UnityEngine;
using SquickStruct;
using Google.Protobuf;
using Squick;

namespace Squick
{
	public class NetEventModule : IModule
	{
		private IKernelModule mKernelModule;
		private ISEventModule mEventModule;
        private HelpModule mHelpModule;
		private NetModule mNetModule;

		public NetEventModule(IPluginManager pluginManager)
        {
            mPluginManager = pluginManager;
        }

		public override void Awake()
        {
            mNetModule = mPluginManager.FindModule<NetModule>();
            mHelpModule = mPluginManager.FindModule<HelpModule>();
			mKernelModule = mPluginManager.FindModule<IKernelModule>();
			mEventModule = mPluginManager.FindModule<ISEventModule>();
        }

        public override void Start()
        {
			mNetModule.AddNetEventCallBack(NetEventDelegation);

			//mNetModule.RegisteredResultCodeDelegation(SquickStruct.EGameEventCode.EGEC_UNKOWN_ERROR, EGEC_UNKOWN_ERROR);
			//mNetModule.RegisteredResultCodeDelegation(SquickStruct.EGameEventCode.EGEC_ACCOUNT_SUCCESS, EGEC_ACCOUNT_SUCCESS);
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

		private void NetEventDelegation(NetEventType eventType)
		{
            Debug.Log(Time.realtimeSinceStartup.ToString() + " Event " + eventType.ToString());

			switch (eventType)
			{
				case NetEventType.Connected:
					mEventModule.DoEvent((int)LoginModule.Event.Connected);
					break;
				case NetEventType.Disconnected:
					mEventModule.DoEvent((int)LoginModule.Event.Disconnected);
                    break;
				case NetEventType.ConnectionRefused:
					mEventModule.DoEvent((int)LoginModule.Event.ConnectionRefused);
                    break;
				default:
					break;
			}
		}
	}
}