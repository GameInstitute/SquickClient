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

    public class UploadDataModule : IModule
    {
        public UploadDataModule(IPluginManager pluginManager)
		{
			mPluginManager = pluginManager;
		}

        IKernelModule mKernelModule;
        LoginModule mLoginModule;
        NetModule mNetModule;

        public override void Awake()
        {
            mKernelModule = mPluginManager.FindModule<IKernelModule>();
            mLoginModule = mPluginManager.FindModule<LoginModule>();
            mNetModule = mPluginManager.FindModule<NetModule>();
        }

		public override void Start()
        {
            mKernelModule.RegisterClassCallBack(Excel.Player.ThisName, OnClassPlayerEventHandler);
        }

        private void OnClassPlayerEventHandler(Guid self, int nContainerID, int nGroupID, Squick.IObject.CLASS_EVENT_TYPE eType, string strClassName, string strConfigIndex)
        {
            
        }

        private void OnPropertyDataHandler(Guid self, string strProperty, DataList.TData oldVar, DataList.TData newVar, Int64 reason)
        {
            switch (newVar.GetType())
            {
                case DataList.VARIANT_TYPE.VTYPE_INT:
                    {
                        mNetModule.RequirePropertyInt(self, strProperty, newVar.IntVal());
                    }
                    break;
                case DataList.VARIANT_TYPE.VTYPE_FLOAT:
                    {
                        mNetModule.RequirePropertyFloat(self, strProperty, newVar.FloatVal());
                    }
                    break;
                case DataList.VARIANT_TYPE.VTYPE_STRING:
                    {
                        mNetModule.RequirePropertyString(self, strProperty, newVar.StringVal());
                    }
                    break;
                case DataList.VARIANT_TYPE.VTYPE_OBJECT:
                    {
                        mNetModule.RequirePropertyObject(self, strProperty, newVar.ObjectVal());
                    }
                    break;
                case DataList.VARIANT_TYPE.VTYPE_VECTOR2:
                    {
                        mNetModule.RequirePropertyVector2(self, strProperty, newVar.Vector2Val());
                    }
                    break;
                case DataList.VARIANT_TYPE.VTYPE_VECTOR3:
                    {
                        mNetModule.RequirePropertyVector3(self, strProperty, newVar.Vector3Val());
                    }
                    break;
                default:
                    break;
            }

        }

        void RecordEventHandler(Guid self, string strRecordName, IRecord.ERecordOptype eType, int nRow, int nCol, DataList.TData oldVar, DataList.TData newVar)
        {

            switch (eType)
            {
                case IRecord.ERecordOptype.Add:
                    {
                        mNetModule.RequireAddRow(self, strRecordName, nRow);
                    }
                    break;
                case IRecord.ERecordOptype.Del:
                    {
                        mNetModule.RequireRemoveRow(self, strRecordName, nRow);
                    }
                    break;
                case IRecord.ERecordOptype.Update:
                    {
                        switch (newVar.GetType())
                        {
                            case DataList.VARIANT_TYPE.VTYPE_INT:
                                {
                                    mNetModule.RequireRecordInt(self, strRecordName, nRow, nCol, newVar);
                                }
                                break;
                            case DataList.VARIANT_TYPE.VTYPE_FLOAT:
                                {
                                    mNetModule.RequireRecordFloat(self, strRecordName, nRow, nCol, newVar);
                                }
                                break;
                            case DataList.VARIANT_TYPE.VTYPE_STRING:
                                {
                                    mNetModule.RequireRecordString(self, strRecordName, nRow, nCol, newVar);
                                }
                                break;
                            case DataList.VARIANT_TYPE.VTYPE_OBJECT:
                                {
                                    mNetModule.RequireRecordObject(self, strRecordName, nRow, nCol, newVar);
                                }
                                break;
                            case DataList.VARIANT_TYPE.VTYPE_VECTOR2:
                                {
                                    mNetModule.RequireRecordVector2(self, strRecordName, nRow, nCol, newVar);
                                }
                                break;
                            case DataList.VARIANT_TYPE.VTYPE_VECTOR3:
                                {
                                    mNetModule.RequireRecordVector3(self, strRecordName, nRow, nCol, newVar);
                                }
                                break;
                            default:
                                break;
                        }
                    }
                    break;
                case IRecord.ERecordOptype.Create:
                    break;
                case IRecord.ERecordOptype.Cleared:
                    {
                       
                    }
                    break;
                default:
                    break;
            }

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
    }

}