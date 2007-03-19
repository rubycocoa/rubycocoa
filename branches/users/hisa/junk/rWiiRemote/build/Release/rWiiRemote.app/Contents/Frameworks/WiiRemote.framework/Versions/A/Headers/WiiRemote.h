//
//  WiiRemote.h
//  DarwiinRemote
//
//  Created by KIMURA Hiroaki on 06/12/04.
//  Copyright 2006 KIMURA Hiroaki. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOBluetooth/objc/IOBluetoothDevice.h>
#import <IOBluetooth/objc/IOBluetoothL2CAPChannel.h>


typedef struct {
	int x, y, s;
} IRData;

typedef struct {
	unsigned char accX_zero, accY_zero, accZ_zero, accX_1g, accY_1g, accZ_1g; 
} WiiAccCalibData;

typedef struct {
	unsigned char x_min, x_max, x_center, y_min, y_max, y_center; 
} WiiJoyStickCalibData;


typedef UInt16 WiiButtonType;
enum {
	WiiRemoteAButton,
	WiiRemoteBButton,
	WiiRemoteOneButton,
	WiiRemoteTwoButton,
	WiiRemoteMinusButton,
	WiiRemoteHomeButton,
	WiiRemotePlusButton,
	WiiRemoteUpButton,
	WiiRemoteDownButton,
	WiiRemoteLeftButton,
	WiiRemoteRightButton,
	
	WiiNunchukZButton,
	WiiNunchukCButton
};


typedef UInt16 WiiAccelerationSensorType;
enum{
	WiiRemoteAccelerationSensor,
	WiiNunchukAccelerationSensor
};


typedef UInt16 WiiJoyStickType;
enum{
	WiiNunchukJoyStick,
	WiiClassicControllerLeftJoyStick,	//not available
	WiiClassicControllerRightJoyStick	//not available
};


@interface WiiRemote : NSObject {
	
	IOBluetoothDevice* wiiDevice;
	IOBluetoothL2CAPChannel *ichan;
	IOBluetoothL2CAPChannel *cchan;
	
	id _delegate;
	
	
	unsigned char accX;
	unsigned char accY;
	unsigned char accZ;
	unsigned short buttonData;
	
	float lowZ, lowX;
	int orientation;
	int leftPoint; // is point 0 or 1 on the left. -1 when not tracking.
	
	WiiAccCalibData wiiCalibData, nunchukCalibData;
	WiiJoyStickCalibData nunchukJoyStickCalibData;
	IRData	irData[4];
	double batteryLevel;
	double warningBatteryLevel;
	
	BOOL isMotionSensorEnabled, isIRSensorEnabled, isVibrationEnabled, isExpansionPortEnabled;
	BOOL isExpansionPortAttached;
	BOOL isLED1Illuminated, isLED2Illuminated, isLED3Illuminated, isLED4Illuminated;
	NSTimer* statusTimer;
	IOBluetoothUserNotification *disconnectNotification;
	BOOL buttonState[13];
	
	
	
	//nunchuk
	unsigned char xStick;
	unsigned char yStick;
	unsigned char nAccX;
	unsigned char nAccY;
	unsigned char nAccZ;
	unsigned char nButtonData;
	
} 

- (NSString*) address;
- (void)setDelegate:(id)delegate;
- (double)batteryLevel;
- (BOOL)isExpansionPortAttached;
- (BOOL)available;
- (BOOL)isButtonPressed:(WiiButtonType)type;
- (WiiJoyStickCalibData)joyStickCalibData:(WiiJoyStickType)type;
- (WiiAccCalibData)accCalibData:(WiiAccelerationSensorType)type;

- (IOReturn)connectTo:(IOBluetoothDevice*)device;
- (IOReturn)closeConnection;
- (IOReturn)setIRSensorEnabled:(BOOL)enabled;
- (IOReturn)setForceFeedbackEnabled:(BOOL)enabled;
- (IOReturn)setMotionSensorEnabled:(BOOL)enabled;
- (IOReturn)setExpansionPortEnabled:(BOOL)enabled;
- (IOReturn)setLEDEnabled1:(BOOL)enabled1 enabled2:(BOOL)enabled2 enabled3:(BOOL)enabled3 enabled4:(BOOL)enabled4;
- (IOReturn)writeData:(const unsigned char*)data at:(unsigned long)address length:(size_t)length;
- (IOReturn)readData:(unsigned long)address length:(unsigned short)length;
- (IOReturn)sendCommand:(const unsigned char*)data length:(size_t)length;


@end


@interface NSObject( WiiRemoteDelegate )

- (void) irPointMovedX:(float)px Y:(float)py;
- (void) buttonChanged:(WiiButtonType)type isPressed:(BOOL)isPressed;
- (void) accelerationChanged:(WiiAccelerationSensorType)type accX:(unsigned char)accX accY:(unsigned char)accY accZ:(unsigned char)accZ;
- (void) joyStickChanged:(WiiJoyStickType)type tiltX:(unsigned char)tiltX tiltY:(unsigned char)tiltY;
- (void) wiiRemoteDisconnected:(IOBluetoothDevice*)device;


//- (void) dataChanged:(unsigned short)buttonData accX:(unsigned char)accX accY:(unsigned char)accY accZ:(unsigned char)accZ mouseX:(float)mx mouseY:(float)my;


@end
