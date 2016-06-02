close all;
%% image
load 'N_25.mat';
%load 'T.mat';
%T = toy_checkerboard(10,10,1);
%T = toy_stripes(400,400,40);
T = imread('la.png');
%%
TureIMG = double(T);
%N = add_noise(T,25);
%N = double(imread('Noise.jpg'));
sigma = 25;
eta = 100;
N = double(N);
%save N;
iter = 1000;
%T = double(median_filter(N,7));
T = N;
lp = zeros(iter,1);
PSNR = zeros(iter,1);
%diffs = zeros(iter,1);
i=1;
while i<=iter
    %diff = denoising_grad_llh(T, N, sigma)+mrf_grad_log_student_prior(T, sigma,1);
    diff = denoising_grad_llh(T, N, sigma)+mrf_grad_log_gaussian_prior(T, sigma);
    T = T + eta*diff;
    lp(i) = denoising_lp(T, N, sigma);
    %diffs(i) = norm(diff);
    %PSNR(i) = calc_psnr(TureIMG, T);
    i=i+1;
end
M = max(max(T));
m = min(min(T));
T = uint8((T-m)*(255/(M-m)));
N = uint8(N);
iter = 1:iter;
figure(1),
subplot(2,1,1);
plot(iter,lp);
ylabel('Log-Posterior');
tit = sprintf('sigma = %.1f, eta = %.2f',sigma, eta);
subplot(2,1,2);
plot(iter,PSNR);
ylabel('PSNR');
xlabel('iter');
figure(2),imshow(N);
figure(3),imshow(T);