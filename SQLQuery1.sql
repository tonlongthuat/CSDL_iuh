CREATE DATABASE BT1
ON PRIMARY
	(NAME=BAI1,
	FILENAME='D:\1.code\SQL_iuh\1.tuan2,3\bai1\BT1.mdf',
	SIZE=10,
	MAXSIZE=50,
	FILEGROWTH=1)
LOG ON 
	(NAME=BAI1_log,
	FILENAME='D:\1.code\SQL_iuh\1.tuan2,3\bai1\BT1_log.ldf',
	SIZE=3,
	MAXSIZE=10,
	FILEGROWTH=1)

use BT1
sp_help
--3. Thực hiện tạo các table trong CSDL QLBH theo thiết kế sau	
create table NhomSanPham
(MaNhom int primary key NOT NULL,
TenNhom Nvarchar(15))

--sp_help NhomSanPham xem tt table

create table NhaCungCap
	(MaNCC Int primary key Not null ,
	TenNCC Nvarchar(40) Not Null ,
	Diachi Nvarchar(60),
	Phone NVarchar(24),
	SoFax NVarchar(24),
	DCMail NVarchar(50)
	)
create table SanPham
	(MaSP int primary key Not null,
	TenSP nvarchar(40) not null,
	MaNCC int references NhaCungCap(MaNCC),
	MoTa nvarchar(50),
	MaNhom int references NhomSanPham(MaNhom),
	DonViTinh nvarchar(20),
	GiaGoc Money CHECK (GiaGoc > 0),
	SLTON int check(SLTON >=0)
	)
create table KhachHang
	(MaKH Char(5) primary key Not null,
	TenKH Nvarchar(40) Not null,
	LoaiKH Nvarchar(3) check (LoaiKH in ('VIP','TV','VL')),
	DiaChi Nvarchar(60),
	Phone NVarchar(24),
	DCMail NVarchar(50),
	DiemTL Int check(DiemTL >=0),
	)
create table HoaDon
	(MaHD int primary key Not null,
	NgayLapHD DateTime default Getdate() check(NgayLapHD >= Getdate()),
	NgayGiao DateTime,
	Noichuyen NVarchar(60) Not Null ,
	MaKH Char(5) references KhachHang(MaKH)
	)
create table CT_HoaDon
	(MaHD Int Not null references HoaDon(MaHD),
	MaSP int Not null references SanPham(MaSP),
	Soluong SmallInt check (Soluong >0),
	Dongia Money,
	ChietKhau Money check(ChietKhau >0),
	primary key (MaHD,MaSP),
	)

--a. Thêm cột LoaiHD vào bảng HoaDon ?
--LoaiHD : kiểu dữ liệu char(1), có giá trị : ‘N’ hoặc ‘X’ hoặc ‘C’ hoặc
--‘T’ ; giá trị mặc định là ‘N’ (với ngữ nghĩa ‘N’ : Nhập, ‘X’: Xuất , ‘C’
--: Chuyển từ cửa hàng này sang cửa hàng khác, ‘T’ : Trả)

alter table HoaDon add LoaiHD char(1) default 'N' check(LoaiHD in ('N','X','C','T'))
sp_help HoaDon
--b. Tạo thêm ràng buộc trên bảng HoaDon : NgayGiao>=NgayLapHD
alter table HoaDon
add constraint NgayGiao check (NgayGiao >= NgayLapHD)
sp_helpconstraint HoaDon

--Thực hiện phát sinh tập tin script cho toàn bộ CSDL QLBH. Đọc hiểu
--các lệnh trong file script. Lưu lại file scrip