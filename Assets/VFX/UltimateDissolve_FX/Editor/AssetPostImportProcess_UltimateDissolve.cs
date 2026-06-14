using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using Orangedkeys.UltimateDissolveFX;
using System.IO;



public class AssetPostImportProcess_UltimateDissolve : AssetPostprocessor
{
    static private bool WelcomeWin = false;
    static void OnPostprocessAllAssets(string[] importedAssets, string[] deletedAssets, string[] movedAssets, string[] movedFromAssetPaths)
    {
        WelcomeWin = false;
        foreach (string item in importedAssets)
        {
            if (Path.GetFileName(item) == "AssetPostImportProcess_UltimateDissolve.cs") WelcomeWin = true;

        }

        foreach (string itemdel in deletedAssets)
        {
            if (Path.GetFileName(itemdel) == "AssetPostImportProcess_UltimateDissolve.cs") WelcomeWin = false;

        }

        if (WelcomeWin)
        {
            Debug.Log("UltimateDissolve FX PACK IMPORTED !!");
            WelcomeUltimateDissolveFX.ShowWindow();
        }





    }

}