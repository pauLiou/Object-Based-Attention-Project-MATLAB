clear acc info protofile Smp pAccuracyData pCalibrationData pEventData pSampleData pSystemInfoData


if(exist('iView','var'))
    if(~isempty(iView))
        iView.iV_StopRecording();
        UnloadiViewXAPI;
    end
end

clear all;