/*------------------------------------------------*/
/***********************************************
          * SD卡读写驱动函数
          * Author:sunwindmcu51
          * **************************************/

//=============================================================
#include "sdcard.h"
#include <unistd.h> 
#include <stdio.h> 
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_alarm.h"
#include "alt_types.h"
#ifdef ENABLE_SD_CARD_DEBUG 
  #define SD_CARD_DEBUG(x)  DEBUG(x) 
#else 
  #define SD_CARD_DEBUG(x) 
#endif 
  
  #define DEBUG(x)   printf(x)
// error macro 
#define INIT_CMD0_ERROR   0x01 
#define INIT_CMD1_ERROR   0x02 
#define WRITE_BLOCK_ERROR 0x03 
#define READ_BLOCK_ERROR  0x04 

#define F_SDCS_HIGH     IOWR_ALTERA_AVALON_PIO_DATA(F_SDCS_BASE, 1)
#define F_SDCS_LOW      IOWR_ALTERA_AVALON_PIO_DATA(F_SDCS_BASE, 0)
#define F_SDCK_HIGH     IOWR_ALTERA_AVALON_PIO_DATA(F_SDCK_BASE, 1)
#define F_SDCK_LOW      IOWR_ALTERA_AVALON_PIO_DATA(F_SDCK_BASE, 0)
#define F_SDIN_HIGH     IOWR_ALTERA_AVALON_PIO_DATA(F_SDIN_BASE, 1)
#define F_SDIN_LOW      IOWR_ALTERA_AVALON_PIO_DATA(F_SDIN_BASE, 0)
#define SDO_F           IORD_ALTERA_AVALON_PIO_DATA(SDO_F_BASE)
#define SDCARD_DELAYS    usleep(10)//
unsigned char DATA[512];
void testsdcard(void);
unsigned char gSD_CARDInit=0;  
//===========================================================
//写一字节到SD卡,模拟SPI总线方式
void SdWrite(unsigned char data)
{

unsigned char i;
 for(i=0;i<8;i++)
{
    if ((data>>(7-i)) & 0x1){ // there is a delay in this command
     F_SDIN_HIGH;
    }
  else{    
        F_SDIN_LOW;
        }
F_SDCK_LOW;
if(gSD_CARDInit) SDCARD_DELAYS;  //SD初始化延时  
F_SDCK_HIGH;
if(gSD_CARDInit) SDCARD_DELAYS; 
}
}
//===========================================================
//从SD卡读一字节,模拟SPI总线方式
unsigned char SdRead()
{
unsigned char nn,i;
nn=0;
 for(i=0;i<8;i++) 
  { // MSB First 
    F_SDCK_LOW;if(gSD_CARDInit)  SDCARD_DELAYS;  
    nn<<=1;if(SDO_F) nn++; 
    F_SDCK_HIGH;if(gSD_CARDInit)  SDCARD_DELAYS;  
  } 
return nn;
}
/********************************/
unsigned char SD_CARD_Write_CMD(unsigned char *CMD) 
{ 
 unsigned char temp,retry; 
  unsigned char i; 
  
  F_SDCS_HIGH; // set chipselect (disable SD-CARD) 
  SdWrite(0xFF); // send 8 clock impulse 
  F_SDCS_LOW; // clear chipselect (enable SD-CARD) 
  
  // write 6 bytes command to SD-CARD 
  for(i=0;i<6;i++) SdWrite(*CMD++); 
  
  // get 16 bits response 
  SdRead(); // read the first byte, ignore it. 
  retry=0; 
  do
  { // only last 8 bits is valid 
    temp=SdRead(); 
    retry++; 
  } 
  while((temp==0xff) && (retry<100)); 
  return temp; 
} 
  
//================================================================
//初始化SD卡
unsigned char SdInit(void)
{
unsigned char i;
unsigned char retry,temp;
unsigned char CMD[]={0x40,0x00,0x00,0x00,0x00,0x95}; 
F_SDCK_HIGH;
F_SDCS_HIGH;
usleep(1000);
SD_CARD_DEBUG(("SD-CARD Init!\n")); 
gSD_CARDInit=1; // Set init flag of SD-CARD 
for(i=0;i<10;i++)
SdWrite(0xff);
retry=0; 
do
{ // retry 200 times to write CMD0 
    temp=SD_CARD_Write_CMD(CMD); 
    retry++; 
    if(retry==200) return INIT_CMD0_ERROR;// CMD0 error! 
  } 
  while(temp!=1); 
CMD[0]=0x41;// Command 1 
 CMD[5]=0xFF; 
  retry=0; 
  do
  { // retry 100 times to write CMD1 
    temp=SD_CARD_Write_CMD(CMD); 
    retry++; 
    if(retry==100)  return INIT_CMD1_ERROR;// CMD1 error! 
  } 
  while(temp!=0); 
  
  gSD_CARDInit=0; // clear init flag of SD-CARD 
  
  F_SDCS_HIGH; // disable SD-CARD 
  SD_CARD_DEBUG(("SD-CARD Init Suc!\n")); 
  return 0x55;// All commands have been taken. 
}
//================================================================
//往SD卡指定地址写数据,一次最多512字节
unsigned char SdWriteBlock(unsigned long address,int len)
{
unsigned int count;
unsigned char i, temp,retry; 
//Block size is 512 bytes exactly
//First Lower SS
unsigned char CMD[]={0x58,0x00,0x00,0x00,0x00,0xFF}; 
 SD_CARD_DEBUG(("Write A Sector Starts!!\n")); 
 CMD[1]=((address & 0xFF000000) >>24 ); 
 CMD[2]=((address & 0x00FF0000) >>16 ); 
 CMD[3]=((address & 0x0000FF00) >>8 ); 
 CMD[4]=(address & 0x000000FF); 
  retry=0; 
  do
  { // retry 100 times to write CMD24 
    temp=SD_CARD_Write_CMD(CMD); 
    retry++; 
    if(retry==100) return(temp);//CMD24 error! 
  } 
  while(temp!=0); 
  
  // before writing, send 100 clock to SD-CARD 
  for(i=0;i<100;i++) SdRead(); 
  
  // write start byte to SD-CARD 
  SdWrite(0xFE); 
  
  SD_CARD_DEBUG(("\n")); 
//now send data
for(count=0;count<len;count++) SdWrite(count);
for(;count<512;count++) SdWrite(0);
//data block sent - now send checksum
SdWrite(0xff); //两字节CRC校验, 为0XFFFF 表示不考虑CRC
SdWrite(0xff);
//Now read in the DATA RESPONSE token
temp=SdRead();
//Following the DATA RESPONSE token
//are a number of BUSY bytes
//a zero byte indicates the MMC is busy

if( (temp & 0x1F)!=0x05 ) // data block accepted ? 
  { 
   F_SDCS_HIGH; // disable SD-CARD 
    return WRITE_BLOCK_ERROR;// error! 
  } 
  
  // wait till SD-CARD is not busy 
  while(SdRead()!=0xff){}; 
  
  F_SDCS_HIGH; // disable SD-CARD 
  
  SD_CARD_DEBUG(("Write Sector suc!!\n")); 
  return 1;
}

//=======================================================================
//从SD卡指定地址读取数据,一次最多512字节
unsigned char SdReadBlock(unsigned char *Block, unsigned long address,int len)
{
unsigned int count;
unsigned char retry; 
unsigned char CMD[]={0x51,0x00,0x00,0x00,0x00,0xFF}; 
unsigned char temp;
  
  CMD[1]=((address & 0xFF000000) >>24 ); 
  CMD[2]=((address & 0x00FF0000) >>16 ); 
  CMD[3]=((address & 0x0000FF00) >>8 ); 
  CMD[4]=(address & 0x000000FF); 
 retry=0; 
  do
  { 
    temp=SD_CARD_Write_CMD(CMD); 
    retry++; 
    if(retry==100) return READ_BLOCK_ERROR;// READ_BLOCK_ERROR 
  } 
  while( temp!=0 ); 

//command was a success - now send data
//start with DATA TOKEN = 0xFE
while(SdRead()!=0xfe);
 SD_CARD_DEBUG(("Open a Sector Succ!\n")); 

for(count=0;count<len;count++) *Block++=SdRead(); 

for(;count<512;count++) SdRead();

//data block sent - now send checksum
SdRead();
SdRead();
F_SDCS_HIGH;
SdRead();
 SD_CARD_DEBUG(("read a Sector Succ!\n")); 
return 1;
}//--------------------------------
/************************************
 * void testsdcard(void)
 * 功能： 读写测试函数
 * 输入参数：
 * 输出参数：
 * ***********************************/

void testsdcard(void)
{
  unsigned long AddTemp;
  SdInit();
 //while(SdInit()!= 0x55); 
 gSD_CARDInit=0;
   AddTemp=331264;//是字节地址
   #ifdef SDWRITE
   SdWriteBlock(AddTemp,512);
   usleep(50); 
    #endif
    usleep(50); 
    #ifdef SDREAD
    SdReadBlock(DATA,AddTemp,512);//每次读出512字节放到缓冲区 
    #endif
}

