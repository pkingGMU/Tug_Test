function data = alignOpals(data,fsR)
global fs;

% ========== ALIGN IMU AXES WITH GLOBAL FRAME ============ %%
        
        iSamples = 1:length(data.time);
        
        nDevices = length(data.sensor);
        offsetV = zeros(nDevices,3);
        offsetA = zeros(nDevices,3);
        cIndex = 1;
        fs = data.sampleRate;
        
        for cDevice = 1:nDevices
            acc = [data.sensor(cDevice).acc.x' data.sensor(cDevice).acc.y' data.sensor(cDevice).acc.z'];
            g = [data.sensor(cDevice).gyro.x' data.sensor(cDevice).gyro.y' data.sensor(cDevice).gyro.z'];
            accR = resample(acc, fsR, fs);
            gR = resample(g .* 180/pi, fsR, fs);
            % ADD BACK RESAMPLE BELOW (acc -> accR)
            [data.sensor(cDevice).acceleration,q] = RotateAcc(accR, fs*2.5);
            % ADD BACK RESAMPLE BELOW (g -> gR)
            data.sensor(cDevice).rotation = RotateVector(gR, q);
            % ADD BACK (acc-accR, g->gR)
            data.sensor(cDevice).accR.x = accR(:,1);
            data.sensor(cDevice).gyroR.x = gR(:,1);
            data.sensor(cDevice).accR.y = accR(:,2);
            data.sensor(cDevice).gyroR.y = gR(:,2);
            data.sensor(cDevice).accR.z = accR(:,3);
            data.sensor(cDevice).gyroR.z = gR(:,3);
            
            % for c = 1:3
            %     data.sensor(cDevice).velocity(:,c) = integrateSig(data.sensor(cDevice).acceleration(:,c))/128;
            %     data.sensor(cDevice).angle(:,c) = integrateSig(data.sensor(cDevice).rotation(:,c))/128*180/pi;
            % 
            %     data.sensor(cDevice).rotationF(:,c) = KernelFilter(data.sensor(cDevice).rotation(:,c),fs,6);
            %     data.sensor(cDevice).accelerationF(:,c) = KernelFilter(data.sensor(cDevice).acceleration(:,c),fs,6);
            % 
            %     data.sensor(cDevice).velocityF(:,c) = integrateSig(data.sensor(cDevice).accelerationF(:,c))/128;
            %     data.sensor(cDevice).angleF(:,c) = integrateSig(data.sensor(cDevice).rotationF(:,c))/128*180/pi;
            % end
        end
end

