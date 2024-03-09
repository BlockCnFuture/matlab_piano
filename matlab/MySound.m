classdef MySound
    properties
        %半音
        K = 2^(1/12);
        %中央C调
        C = 261.63;
        %设置节拍为3000ms
        P = 3000;
    end
    methods (Access = private)
        function o_sound(obj,freq,duration) %频率,播放时长
            Fs = 8000; % 采样率
            if freq==0
                t = 0:1/Fs:duration/1000; % 时间向量，ms
                % 创建长度相同的零向量
                y = zeros(size(t));  
                disp('休止符');                
            else
                t = 0:1/Fs:duration/1000; % 时间向量，ms
                y = 1*sin(2*pi*freq*t); % 生成sin波 幅度为1
                disp([num2str(freq),' HZ']);                
            end
            
            player = audioplayer(y, Fs);
            
            % 播放声音并等待播放完成
            playblocking(player);
        end
        
        function result=o_sound_Creat(obj,freq,duration) %频率,播放时长
            Fs = 8000; % 采样率
            y=[];
            if freq~=0
                t = 0:1/Fs:duration/1000; % 时间向量，ms
                y = 1*sin(2*pi*freq*t); % 生成sin波 幅度为1                
            else
                t = 0:1/Fs:duration/1000; % 时间向量，ms
                % 创建长度相同的零向量
                y = zeros(size(t));  
            end
            result=y;
        end
        
        function Sound_Byname(obj,name,duration,ex) %音名,播放时长,提升八度
            %从F0开始各音名依次升高
            names = ["F0","Gb0","G0","Ab0","A0","Bb0","B0","C1","Db1","D1","Eb1","E1","F1","Gb1","G1","Ab1","A1","Bb1","B1","C2","Db2","D2","Eb2","E2","F2","0"];
            for i = 1:length(names)
                if strcmp(names(i), name)
                    f=174.61; %F0的频率
                    freq=f*(obj.K^(i-1)); %从F0导出其他音名的频率
                    freq=freq*(2^ex); %每提升一个八度，频率变成原来的2倍，每降低一个八度，频率变成原来的1/2倍
                    if strcmp(names(i), "0")
                        freq=0;
                    end
                    obj.o_sound(freq,duration);
                    return;
                end
            end
        end
        
end
    
    methods
        
        function result=SoundCreat_Byname(obj,name,duration,ex) %音名,播放时长,提升八度
            %从F0开始各音名依次升高
            names = ["F0","Gb0","G0","Ab0","A0","Bb0","B0","C1","Db1","D1","Eb1","E1","F1","Gb1","G1","Ab1","A1","Bb1","B1","C2","Db2","D2","Eb2","E2","F2","0"];
            for i = 1:length(names)
                if strcmp(names(i), name)
                    f=174.61; %F0的频率
                    freq=f*(obj.K^(i-1)); %从F0导出其他音名的频率
                    freq=freq*(2^ex); %每提升一个八度，频率变成原来的2倍，每降低一个八度，频率变成原来的1/2倍
                    if strcmp(names(i), "0")
                        freq=0;
                    end
                    result=obj.o_sound_Creat(freq,duration);
                end
            end
        end
        
        %C大调
        function Sound_C(obj,key,duration,ex)
            keys=['0','1','2','3','4','5','6','7','i'];
            names=["0","C1","D1","E1","F1","G1","A1","B1","C2"];
            for i=1:length(keys)
                if strcmp(keys(i), key)
                    obj.Sound_Byname(names(i),duration,ex);
                end
            end
        end
        
        %F大调
        function Sound_F(obj,key,duration,ex)
            keys=['0','1','2','3','4','5','6','7','i'];
            names=["0","F1","G1","A1","Bb1","C2","D2","E2","F2"];
            for i=1:length(keys)
                if strcmp(keys(i), key)
                    obj.Sound_Byname(names(i),duration,ex);
                end
            end
        end
        
        %C大调
        function result=SoundCreat_C(obj,key,duration,ex)
            keys=['0','1','2','3','4','5','6','7','i'];
            names=["0","C1","D1","E1","F1","G1","A1","B1","C2"];
            for i=1:length(keys)
                if strcmp(keys(i), key)
                    result=obj.SoundCreat_Byname(names(i),duration,ex);
                end
            end
        end
        
        %F大调
        function result=SoundCreat_F(obj,key,duration,ex)
            keys=['0','1','2','3','4','5','6','7','i'];
            names=["0","F1","G1","A1","Bb1","C2","D2","E2","F2"];
            for i=1:length(keys)
                if strcmp(keys(i), key)
                    result=obj.SoundCreat_Byname(names(i),duration,ex);
                end
            end
        end

        %获取节拍长度
        function result=Get_P(obj)
            result=obj.P;
        end
        
    end
end