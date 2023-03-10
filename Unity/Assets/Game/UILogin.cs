using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using Squick;
using System.Text;
using UnityEngine.SceneManagement;

public class UILogin : MonoBehaviour
{
    private ISEventModule mEventModule;
    private NetModule mNetModule;
    private LoginModule mLoginModule;
    private HelpModule mHelpModule;

    public InputField mAccount;
    public InputField mPassword;
    public Button mLogin;
    // Use this for initialization


    void Start()
    {
        // 查找基本模块
        mEventModule = SquickRoot.instance.GetPluginManager().FindModule<ISEventModule>();
        mNetModule = SquickRoot.instance.GetPluginManager().FindModule<NetModule>();
        mLoginModule = SquickRoot.instance.GetPluginManager().FindModule<LoginModule>();
        mHelpModule = SquickRoot.instance.GetPluginManager().FindModule<HelpModule>();


        // 监听登录按钮
        mLogin.onClick.AddListener(OnLoginClick);

        // 注册回调函数
        mEventModule.RegisterCallback((int)LoginModule.Event.LoginSuccess, OnLoginSuccess);
        mEventModule.RegisterCallback((int)LoginModule.Event.EnterLobbySuccess, OnEnterLobbySuccess);
    }

    // UI Event
    private void OnLoginClick()
    {
        Debug.Log("登录中...");
        // 点击登录
        PlayerPrefs.SetString("account", mAccount.text);
        PlayerPrefs.SetString("password", mPassword.text);
        mLoginModule.OnReqLogin(mAccount.text, mPassword.text);
    }

    // Logic Event
    public void OnLoginSuccess(int eventId, DataList valueList)
    {
        Debug.Log("登录成功！");
        // 进入大厅
        mLoginModule.OnReqEnter();
    }

    public void OnEnterLobbySuccess(int eventId, DataList valueList)
    {
        Debug.Log("进入游戏大厅");
        SceneManager.LoadScene("Game");
    }
}