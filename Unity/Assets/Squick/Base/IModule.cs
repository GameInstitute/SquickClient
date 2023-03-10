using UnityEngine;
using System.Collections;

namespace Squick
{
	public abstract class IModule
	{
		public abstract void Awake();
		public abstract void Start();
		public abstract void AfterStart();
		public abstract void Update();
		public abstract void BeforeDestroy();
		public abstract void Destroy();

        public IPluginManager mPluginManager;
        public string mName;
    };
}