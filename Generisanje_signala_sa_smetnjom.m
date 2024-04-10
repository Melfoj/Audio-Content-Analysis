clear all;
close all;
clc;

%% Ucitavanje signala
for b=["_govor.wav","_muzika_rock.wav","_muzika_pop.wav","_muzika_rnb.wav"]
    ch=convertStringsToChars(b);
    for a=1:10
        %% Ucitavanje smetnje
        [sum fs_sum] = audioread("Signali\Sum\sum.wav");
        sum=sum';
        file_name=sprintf('%d',a);
        switch b
        case "_govor.wav"
            write_name=['Signali\Sum\Govor\',file_name,ch(1:end-4),'_sum.wav'];
            file_name=['Signali\Cisti\Govor\',file_name,ch];
        case "_muzika_rock.wav"
            write_name=['Signali\Sum\Rock\',file_name,ch(1:end-4),'_sum.wav'];
            file_name=['Signali\Cisti\Rock\',file_name,ch];
        case "_muzika_pop.wav"
            write_name=['Signali\Sum\Pop\',file_name,ch(1:end-4),'_sum.wav'];
            file_name=['Signali\Cisti\Pop\',file_name,ch];
        case "_muzika_rnb.wav"
            write_name=['Signali\Sum\RnB\',file_name,ch(1:end-4),'_sum.wav'];
            file_name=['Signali\Cisti\RnB\',file_name,ch];
        otherwise
            warning('No such signal.')
        end
        file_name=convertCharsToStrings(file_name);
        [x,fs] = audioread(file_name);
        x=x';
        if fs~=fs_sum
            fs_resamp = fs_sum;
            [Numer, Denom] = rat(fs_resamp/fs);
            x = resample(x, Numer, Denom);
        end
        if length(x)>length(sum)
            x = x(1:length(sum));
        else
            sum = sum(1:length(x));
        end

        %% Generisanje tona sa smetnjom 
        x_sum = x + sum;
        % Normalizacija
        x_sum = x_sum/max(abs(x_sum));
        write_name=convertCharsToStrings(write_name);
        audiowrite(write_name,x_sum,fs_sum);
    end
end