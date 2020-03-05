clc
close all; clear all;
rng default
filename = 'test_data.xlsx';
sheetname1 = 'Sheet1';
sheetname2 = 'Sheet2';
input = xlsread(filename,sheetname1,'A1:Z10000');
target = xlsread(filename,sheetname2,'A1:Z10000');
inputs=input';
targets=target';
net=newff([1 0;1 0;0 1;2 3],[336,1],{'tansig','purelin'},'trainlm');
net = init(net);
a = sim(net,inputs);
net=newff(minmax(inputs),[336,1],{'tansig','purelin'},'trainlm');
net.trainParam.show = 5;
net.trainParam.lr = 10000;
net.trainParam.epochs = 15000;
net.trainParam.goal = .0000001;
[net,tr]=train(net,inputs,targets);
ANN_output = sim(net,inputs);
w1 = net.IW{1}; %the input-to-hidden layer weights
w2 = net.LW{2}; %the hidden-to-output layer weights
b1 = net.b{1}; %the input-to-hidden layer bias
b2 = net.b{2}; %the hidden-to-output layer bias
error_output = gsubtract(targets,ANN_output);
figure
performance = perform(net,targets,ANN_output);
n{1} = tansig(net.IW{1,1}*inputs + net.b{1});
n{2}= purelin(w2*n{1}+b2);
view(net)
figure, plotperform(tr)
figure, plottrainstate(tr)
figure, ploterrhist(error_output)