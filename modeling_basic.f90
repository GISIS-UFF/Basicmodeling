Program Modeling
implicit none

integer :: k,i,j
integer :: count_snap
integer :: Nx,Nz,Nt
integer :: sx,sz
integer :: Nt_src

real :: h,dt
real :: fcut, fcut_aux
real :: t_src,t0_src,src_aux
real, parameter :: pi = 4.0*ATAN(1.0)

real,allocatable,dimension(:) :: source
real,allocatable,dimension(:,:) :: P1,P2,P3,C
real,allocatable,dimension(:,:) :: Seism

! model parameters
Nx=301
Nz=301
h=10

! time parameters
Nt=1001
dt=1.0e-3

!source parameters
sx=150
sz=20
fcut = 30

! Allocate arrays
allocate(source(Nt))
allocate(C(Nz,Nx))
allocate(P1(Nz,Nx))
allocate(P2(Nz,Nx))
allocate(P3(Nz,Nx))
allocate(Seism(Nt,Nx))

!Initializate arrays and counters
count_snap=1
source = 0.0
P1 =0.0
P2 =0.0
P3 =0.0
C = 1500

! Create Source Ricker
fcut_aux       = fcut/(3.*sqrt(pi))        ! Ajust to cut of gaussian function
t0_src   = 4*sqrt(pi)/fcut                 ! Initial time source
Nt_src = nint(2*t0_src/dt) + 1           ! Number of elements of the source
do k=1,Nt_src                          !Nts=nint(tm/dt)+1
    t_src=(k-1)*dt-t0_src                    !Delay Time
    src_aux=pi*(pi*fcut_aux*t_src)*(pi*fcut_aux*t_src)
    source(k) = (2*src_aux-1)*exp(-src_aux)    
 end do

 ! Register in disk
 open(23, file='snapshots.bin', status='replace',&
 &FORM='unformatted',ACCESS='direct', recl=(Nx*Nz*4))

 open(24, file='seismogram.bin', status='replace',&
 &FORM='unformatted',ACCESS='direct', recl=(Nx*Nt*4))

 ! Solve wave equation
do k=1,Nt

    ! source term
    P2(sz,sx) = P2(sz,sx) + source(k)    

    !wave equation
    do i=3,Nx-2
        do j=3,Nz-2                
        !4th order in space and 2nd order in time
         P3(j,i)=2*P2(j,i)-P1(j,i) + ((C(j,i)*C(j,i))*(dt*dt)/(12*h*h)) &
                &*(-(P2(j,i-2) + P2(j-2,i) + P2(j+2,i) + P2(j,i+2)) + & 
                &16*(P2(j,i-1) + P2(j-1,i) + P2(j+1,i) + P2(j,i+1))- &
                &60*P2(j,i))
        end do
    end do
    
    !Register snapshots
    if (mod(k,100) ==0) then
    write(23,rec=count_snap) ((P3(j,i),j=1,Nz),i=1,Nx)
    count_snap=count_snap+1
    end if

    ! update fields
    P1=P2
    P2=P3
    
    !Storage Seismogram
    Seism(k,:) = P2(3,:)

end do

!Register Seismogram
write(24,rec=1) ((Seism(k,i),k=1,Nt),i=1,Nx)

!close files
close(23)
close(24)
end program