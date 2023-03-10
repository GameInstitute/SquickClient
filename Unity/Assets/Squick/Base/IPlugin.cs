using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace Squick
{
    public abstract class IPlugin : IModule
    {
        //------------- 接口 -------------------//
        public abstract string GetPluginName();
        public abstract void Install();
        public abstract void Uninstall();
        public override void Awake()
        {
            foreach (IModule module in mModules.Values)
            {
                if (module != null)
                {
                    module.Awake();
                }
            }
        }

        public override void Start()
        {
            foreach (IModule module in mModules.Values)
            {
                if (module != null)
                {
                    module.Start();
                }
            }
        }

        public override void AfterStart()
        {
            foreach (IModule module in mModules.Values)
            {
                if (module != null)
                {
                    module.AfterStart();
                }
            }
        }

        public override void Update()
        {
            foreach (IModule module in mModules.Values)
            {
                if (module != null)
                {
					module.Update();
                }
            }
        }

        public override void BeforeDestroy()
        {
            foreach (IModule module in mModules.Values)
            {
                if (module != null)
                {
                    module.BeforeDestroy();
                }
            }
        }

        public override void Destroy()
        {
            foreach (IModule module in mModules.Values)
            {
                if (module != null)
                {
                    module.Destroy();
                }
            }
        }

        public void AddModule<T1>(IModule module)
        {
            string strName = typeof(T1).ToString();
            mPluginManager.AddModule(strName, module);
            mModules.Add(strName, module);
        }

        protected Dictionary<string, IModule> mModules = new Dictionary<string, IModule>();
    };
}