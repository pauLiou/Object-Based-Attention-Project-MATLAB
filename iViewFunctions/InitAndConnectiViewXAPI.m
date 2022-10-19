% -----------------------------------------------------------------------
%
% (c) Copyright 1997-2017, SensoMotoric Instruments GmbH
%
% Permission  is  hereby granted,  free  of  charge,  to any  person  or
% organization  obtaining  a  copy  of  the  software  and  accompanying
% documentation  covered  by  this  license  (the  "Software")  to  use,
% reproduce,  display, distribute, execute,  and transmit  the Software,
% and  to  prepare derivative  works  of  the  Software, and  to  permit
% third-parties to whom the Software  is furnished to do so, all subject
% to the following:
%
% The  copyright notices  in  the Software  and  this entire  statement,
% including the above license  grant, this restriction and the following
% disclaimer, must be  included in all copies of  the Software, in whole
% or  in part, and  all derivative  works of  the Software,  unless such
% copies   or   derivative   works   are   solely   in   the   form   of
% machine-executable  object   code  generated  by   a  source  language
% processor.
%
% THE  SOFTWARE IS  PROVIDED  "AS  IS", WITHOUT  WARRANTY  OF ANY  KIND,
% EXPRESS OR  IMPLIED, INCLUDING  BUT NOT LIMITED  TO THE  WARRANTIES OF
% MERCHANTABILITY,   FITNESS  FOR  A   PARTICULAR  PURPOSE,   TITLE  AND
% NON-INFRINGEMENT. IN  NO EVENT SHALL  THE COPYRIGHT HOLDERS  OR ANYONE
% DISTRIBUTING  THE  SOFTWARE  BE   LIABLE  FOR  ANY  DAMAGES  OR  OTHER
% LIABILITY, WHETHER  IN CONTRACT, TORT OR OTHERWISE,  ARISING FROM, OUT
% OF OR IN CONNECTION WITH THE  SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
%
% -----------------------------------------------------------------------
%
%
% Load the iViewX API library and connect to the server
%
% Author: SMI GmbH

% Initializate Library

if strcmp(computer('arch'), 'win64')
    libDLLName = 'iViewXAPI64.dll';
    protofile = @iViewXAPIHeader64;
else
    libDLLName = 'iViewXAPI.dll';
    protofile = @iViewXAPIHeader;
end   

loadlibrary(libDLLName, protofile, 'alias', 'iViewXAPI');

if ~libisloaded('iViewXAPI')
    error('%s not loaded!', libDDLName);
end
    
disp(strcat(libDLLName,' loaded'))

[pSystemInfoData, pSampleData, pEventData, pAccuracyData, CalibrationData] = InitiViewXAPI();

CalibrationData.method = int32(5);
CalibrationData.visualization = int32(1);
CalibrationData.displayDevice = int32(0);
CalibrationData.speed = int32(0);
CalibrationData.autoAccept = int32(1);
% if colorScheme == 0 %black and white
CalibrationData.foregroundBrightness = int32(250);
CalibrationData.backgroundBrightness = int32(0);
% else
%     CalibrationData.foregroundBrightness = int32(250);
%     CalibrationData.backgroundBrightness = int32(125);
% end
CalibrationData.targetShape = int32(2);
CalibrationData.targetSize = int32(30);
CalibrationData.targetFilename = int8('');
pCalibrationData = libpointer('CalibrationStruct', CalibrationData);

%Create structure with function wrappers
iView = iViewXAPI;

%Create logger file
disp('Define Logger')
ret_log= iView.iV_SetLogger(int32(1), 'iViewXSDK_log.txt');

if ret_log ~= 1
    disp('Logger could not be opened')
end

%Connect to server
disp('Connecting to iViewX')
ret_con = iView.iV_Connect('127.0.0.1', int32(4444), '127.0.0.1', int32(5555));

msg = 'Connection to the Eyetracker could not be established. Please check the message box or logfile for further information'; 
switch ret_con
    case 1
        connected = 1;
        disp('Connection was successful')
    case 104
        msgbox('Could not establish connection. Check if Eye Tracker is running', 'Connection Error', 'modal');
        error(msg);
    case 105
        msgbox('Could not establish connection. Check the communication Ports', 'Connection Error', 'modal');
        error(msg);
    case 123
        msgbox('Could not establish connection. Another Process is blocking the communication Ports', 'Connection Error', 'modal');
        error(msg);
    case 200
        msgbox('Could not establish connection. Check if Eye Tracker is installed and running', 'Connection Error', 'modal');
        error(msg);
    otherwise
        msgbox('Could not establish connection', 'Connection Error', 'modal');
        error(msg);
end

