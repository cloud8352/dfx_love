//#pragma comment( linker, "/subsystem:\"windows\" /entry:\"mainCRTStartup\"")
#include<stdio.h>
#include <windows.h>

int main()
{

    //WinExec("cmd.exe /c dir > ./run.txt", SW_HIDE);
    WinExec("./love2d/love.exe ./", SW_SHOWDEFAULT);

    //while(1);
 /*   char c[100];

    FILE * fp1 = fopen("run.txt", "r");//打开输入文件
    if (fp1==NULL) {                   //若打开文件失败则退出
        puts("不能打开文件！");
        return 0;
    }

    fgets(c,100,fp1);                  //从输入文件读取一行字符串

    system(c);

    */
    return 0;
}
