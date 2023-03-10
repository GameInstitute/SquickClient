using System;
using System.Linq;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using Squick;
using UnityEngine;

namespace Squick
{
	public class LagTestModule : IModule
    {
        private NetModule mNetModule;
        private Dictionary<int, float> mLagTestData = new Dictionary<int, float>();
        private int index = 0;
        private Ping ping;

        public int gateLagTime = 0;
        public int gameLagTime = 0;
        public int netLagTime = 0;

        List<int> gateLagTimeList = new List<int>();
        List<int> gameLagTimeList = new List<int>();

        public LagTestModule(IPluginManager pluginManager)
		{
			mPluginManager = pluginManager;
		}

		public override void Awake()
        {
            mNetModule = mPluginManager.FindModule<NetModule>();
        }

		public override void Start()
        {
        }

		public override void AfterStart()
        {
            mNetModule.AddReceiveCallBack((int)SquickStruct.ProxyRPC.AckHeartbeat, EGEC_ACK_GATE_LAG_TEST);
        }

        float lastTime = 0f;
		public override void Update()
		{
            // send a lag test message per 5 seconds
            if (Time.realtimeSinceStartup - lastTime > 5f)
            {
                lastTime = Time.realtimeSinceStartup;

                SendLagTest();
                //PingTest();
            }
        }

		public override void BeforeDestroy()
		{
		}

		public override void Destroy()
		{
		}

        private void PingTest()
        {
            ping = null;

            if (mNetModule.strGameServerIP != null)
            {
                ping = new Ping(mNetModule.strGameServerIP);
            }
        }

        private void SendLagTest()
        {
            index++;

            mNetModule.OnReqHeartBeat(index);

            mLagTestData.Add(index, Time.realtimeSinceStartup);
        }

        private void EGEC_ACK_GATE_LAG_TEST(int id, MemoryStream stream)
        {
            SquickStruct.MsgBase xMsg = SquickStruct.MsgBase.Parser.ParseFrom(stream);

            SquickStruct.ReqHeartBeat xData = SquickStruct.ReqHeartBeat.Parser.ParseFrom(xMsg.MsgData);

            float time;
            if (mLagTestData.TryGetValue(xData.Index, out time))
            {
                float lagTime = Time.realtimeSinceStartup - time;
                gateLagTime = (int)(lagTime * 1000);

                if (gateLagTimeList.Count > 10)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("gateLagTime:");
                    foreach (var item in gateLagTimeList)
                    {
                        sb.Append(item);
                        sb.Append(",");
                    }

                    Debug.Log(sb.ToString());

                    gateLagTimeList.Clear();
                }
            }
        }

        void EGEC_ACK_GAME_LAG_TEST(int id, MemoryStream stream)
        {
            SquickStruct.MsgBase xMsg = SquickStruct.MsgBase.Parser.ParseFrom(stream);

            SquickStruct.ReqHeartBeat xData = SquickStruct.ReqHeartBeat.Parser.ParseFrom(xMsg.MsgData);

            float time;
            if (mLagTestData.TryGetValue(xData.Index, out time))
            {
                float lagTime = Time.realtimeSinceStartup - time;
                gameLagTime = (int)(lagTime * 1000);

                gateLagTimeList.Add(gateLagTime);

                if (gameLagTimeList.Count > 10)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("gameLagTime:");
                    foreach (var item in gateLagTimeList)
                    {
                        sb.Append(item);
                        sb.Append(",");
                    }

                    Debug.Log(sb.ToString());

                    gameLagTimeList.Clear();
                }

                mLagTestData.Remove(xData.Index);
            }
        }
    }

}