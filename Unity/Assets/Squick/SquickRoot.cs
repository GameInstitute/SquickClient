
using UnityEngine;
using System.Collections;
using Squick;

public enum GAME_MODE
{
    GAME_MODE_NONE,
    GAME_MODE_2D,
    GAME_MODE_3D,
};

public class SquickRoot : MonoBehaviour
{
    public string serverIp = "192.168.0.142";
    public int port = 15001;
    private GAME_MODE mGameMode = GAME_MODE.GAME_MODE_NONE;
    public IKernelModule kernel;
    public NetModule net;
    public LoginModule login;
    public PluginManager pluginManager;
    
    public static SquickRoot instance = null;

    public GAME_MODE GetGameMode()
    {
        return this.mGameMode;
    }
    public void SetGameMode(GAME_MODE mode)
    {
        this.mGameMode = mode;
    }

    public IPluginManager GetPluginManager()
    {
        return pluginManager;
    }

    private void Awake()
    {
        pluginManager = new PluginManager();  // 创建插件管理器

        instance = this;
        RenderSettings.fog = false;

        pluginManager.Registered(new SquickPlugin(pluginManager));   // 注册SDK插件


        // 获取基本模块
        kernel = pluginManager.FindModule<IKernelModule>();
        net = pluginManager.FindModule<NetModule>();
        login = pluginManager.FindModule<LoginModule>();

        pluginManager.Awake();
        

        // 连接服务器
        net.StartConnect(serverIp, port);
        DontDestroyOnLoad(gameObject);
    }

    void Start()
    {
        pluginManager.Start();
        pluginManager.AfterStart();
    }

    void OnDestroy()
    {
        Debug.Log("Root OnDestroy");
        pluginManager.BeforeDestroy();
        pluginManager.Destroy();
        pluginManager = null;
    }

    void Update()
    {
        pluginManager.Update();
    }
}
