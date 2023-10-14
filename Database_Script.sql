
create database QuanLyThuVien
go
use QuanLyThuVien 

CREATE TABLE Truong
(
	MaTruong nchar(10),
	TenTruong nvarchar(50),
	DiaChi nvarchar(60),
	Email nvarchar(50),
	CONSTRAINT PK_Truong PRIMARY KEY(MaTruong)
)

CREATE TABLE NhanVien
(
	MaNhanVien nchar(10),
	TenNhanVien nvarchar(50),
	CONSTRAINT PK_NhanVien PRIMARY KEY(MaNhanVien)
)

CREATE TABLE LopHuongDan
(
	MaLop nchar(10),
	TenLop nvarchar(50),
	ThoiGianBatDau datetime,
	ThoiGianKetThuc datetime,
	SoLuong tinyint, 
	SoLuongThamGia tinyint,
	CONSTRAINT PK_LopHuongDan PRIMARY KEY(MaLop)
)

CREATE TABLE NhaThanhLy
(
	MaNhaThanhLy nchar(10),
	TenNhaThanhLy nvarchar(50),
	CONSTRAINT PK_NhaThanhLy PRIMARY KEY(MaNhaThanhLy)
)

CREATE TABLE DanhMucThanhLy
(
	MaDanhMuc nchar(10),
	ThoiGianCho date,
	SoSach nvarchar(50),
	TinhTrang int,
	MaNhaThanhLy nchar(10),
	CONSTRAINT PK_DMTL PRIMARY KEY(MaDanhMuc)
)

CREATE TABLE NhaXuatBan
(
	MaNXB nchar(10),
	TenNXB nvarchar(50),
	DiaChi nvarchar(60),
	Email nvarchar(50),
	CONSTRAINT PK_NXB PRIMARY KEY(MaNXB)
)

--TACGIA( MaTacGia, TenTacGia, Email, NgaySinh)
CREATE TABLE TacGia
(
	MaTacGia nchar(10),
	TenTacGia nvarchar(50),
	Email nvarchar(50),
	NgaySinh date
	CONSTRAINT PK_TacGia PRIMARY KEY(MaTacGia)
)
--DOITUONGDOCGIA( MaDoiTuong, TenDoiTuong, LePhi)
CREATE TABLE DoiTuongDocGia
(
	MaDoiTuong nchar(10),
	TenDoiTuong nvarchar(50),
	LePhi money,
	CONSTRAINT PK_DTDocGia PRIMARY KEY(MaDoiTuong)
)
--DOCGIA( MaDocGia, TenDocGia, Email, SDT, TinhTrang, MaTruong, MaLop, MaDoiTuong) 
CREATE TABLE DocGia
(
	MaDocGia nchar(10),
	TenDocGia nvarchar(50),
	Email nvarchar(50),
	SDT nchar(10),
	TinhTrang nvarchar(50),
	MaTruong nchar(10),
	MaLop nchar(10),
	MaDoiTuong nchar(10),
	CONSTRAINT PK_DocGia PRIMARY KEY(MaDocGia)
)

-- NHOMSACH( MaNhomSach, TenNhomSach)
CREATE TABLE NhomSach
(
	MaNhomSach nchar(10),
	TenNhomSach nvarchar(50),
	CONSTRAINT PK_NhomSach PRIMARY KEY(MaNhomSach)
)
-- KHUNGPHANLOAI( MaKPL, TenKPL, MaNhomSach)
CREATE TABLE KhungPhanLoai
(
	MaKPL nchar(10),
	TenKPL nvarchar(50),
	MaNhomSach nchar(10),
	CONSTRAINT PK_KhungPL PRIMARY KEY(MaKPL)
)

-- SACH(ISBN, TenSach, NamXuatBan, Gia, TinhTrang, MaNXB, MaKPL)
CREATE TABLE Sach
(
	ISBN nchar(10),
	TenSach nvarchar(50),
	NamXuatBan nchar(4),
	Gia money,
	TinhTrang nvarchar(50),
	MaNXB nchar(10),
	MaKPL nchar(10),
	CONSTRAINT PK_Sach PRIMARY KEY(ISBN)
)
-- BANSAOLUU( ISBN, STT, TinhTrang)
CREATE TABLE BanSaoLuu
(
	ISBN nchar(10),
	STT int,
	TinhTrang nvarchar(50),
	CONSTRAINT PK_BanSaoLuu PRIMARY KEY(ISBN,STT)
)

-- PHIEUMUON(SoPhieuMuon, NgayLapPhieu, SoLuong, ThoiHan, MaNhanVien, MaDocGIa)
CREATE TABLE PhieuMuon
(
	SoPhieuMuon nchar(10),
	NgayLapPhieu datetime,
	SoLuong tinyint,
	ThoiHan tinyint,
	MaNhanVien nchar(10),
	MaDocGia nchar(10),
	CONSTRAINT PK_PhieuMuon PRIMARY KEY(SoPhieuMuon)
)
-- PHIEUTRA(SoPhieuTra, NgayLapPhieu,SoLuong, SoTienPhat, SoPhieuMuon,MaNhanVien)
CREATE TABLE PhieuTra
(
	SoPhieuTra nchar(10),
	NgayLapPhieu datetime,
	SoLuong tinyint,
	SoTienPhat money,
	SoPhieuMuon nchar(10),
	MaNhanVien nchar(10),
	CONSTRAINT PK_PhieuTra PRIMARY KEY(SoPhieuTra)
)


--CT_PHIEUTRA(SoPhieuTra, ISBN,STT, SoLuong, TienPhat, TinhTrang)

CREATE TABLE CT_PhieuTra
(
	SoPhieuTra nchar(10),
	ISBN nchar(10),
	STT int,
	TienPhat money,
	TinhTrang nvarchar(50),
	CONSTRAINT PK_CT_PhieuTra PRIMARY KEY(SoPhieuTra,ISBN,STT)
)
--CT_PHIEUMUON(SoPhieuMuon, ISBN, STT,  SoLuong)
CREATE TABLE CT_PhieuMuon
(
	SoPhieuMuon nchar(10),
	ISBN nchar(10),
	STT int,
	CONSTRAINT PK_CT_PhieuMuon PRIMARY KEY(SoPhieuMuon,ISBN,STT)
)
--CT_TACGIA_SACH(ISBN, MaTacGia)
CREATE TABLE CT_TacGia_Sach
(
	ISBN nchar(10),
	MaTacGia nchar(10),
	CONSTRAINT PK_TacGia_Sach PRIMARY KEY(ISBN,MaTacGia)
)
--CT_DMTL_BANSAOLUU(MaDanhMuc, ISBN,STT)
CREATE TABLE CT_DMTL_BanSaoLuu
(
	MaDanhMuc nchar(10),
	ISBN nchar(10),
	STT int,
	CONSTRAINT PK_DMTL_BSL PRIMARY KEY(MaDanhMuc,ISBN,STT)
)
--Khoa Ngoai
--Doc Gia
alter table DocGia
add constraint FK_DocGia_Truong foreign key(MaTruong) references Truong(MaTruong)

alter table DocGia
add constraint FK_DocGia_LopHD foreign key(MaLop) references LopHuongDan(MaLop)

alter table DocGia
add constraint FK_DocGia_DoiTuongDG foreign key(MaDoiTuong) references DoiTuongDocGia(MaDoiTuong)

--Phieu Muon
alter table PhieuMuon
add constraint FK_PhieuMuon_NhanVien foreign key(MaNhanVien) references NhanVien(MaNhanVien)

alter table PhieuMuon
add constraint FK_PhieuMuon_DocGia foreign key(MaDocGia) references DocGia(MaDocGia)

--Phieu Tra

alter table PhieuTra
add constraint FK_PhieuTra_PhieuMuon foreign key(SoPhieuMuon) references PhieuMuon(SoPhieuMuon)

alter table PhieuTra
add constraint FK_PhieuTra_NhanVien foreign key(MaNhanVien) references NhanVien(MaNhanVien)

--CT_PhieuMuon
alter table CT_PhieuMuon
add constraint FK_CTPM_PhieuMuon foreign key(SoPhieuMuon) references PhieuMuon(SoPhieuMuon)

alter table CT_PhieuMuon
add constraint FK_CTPM_BSL foreign key(ISBN,STT) references BanSaoLuu(ISBN,STT)


--CT_PhieuTra
alter table CT_PhieuTra
add constraint FK_CTPT_PhieuTra foreign key(SoPhieuTra) references PhieuTra(SoPhieuTra)

alter table CT_PhieuTra
add constraint FK_CTPT_BSL foreign key(ISBN,STT) references BanSaoLuu(ISBN,STT)

----BanSaoLuu
alter table BanSaoLuu 
add constraint FK_BSL_Sach foreign key(ISBN) references Sach(ISBN)

--CT_DMTL_BANSAOLUU
alter table CT_DMTL_BanSaoLuu
add constraint FK_DMTL_BanSaoLuu foreign key(MaDanhMuc) references DanhMucThanhLy(MaDanhMuc)

alter table CT_DMTL_BanSaoLuu
add constraint FK_BanSaoLuu_DMTL foreign key(ISBN,STT) references BanSaoLuu(ISBN,STT)

--CT_TACGIA_SACH
alter table CT_TacGia_Sach
add constraint FK_TacGia_Sach foreign key(ISBN) references Sach(ISBN)

alter table CT_TacGia_Sach
add constraint FK_Sach_TacGia foreign key(MaTacGia) references TacGia(MaTacGia)

--Sach
alter table Sach
add constraint FK_Sach_NXB foreign key(MaNXB) references NhaXuatBan(MaNXB)
alter table Sach
add constraint FK_Sach_KPL foreign key(MaKPL) references KhungPhanLoai(MaKPL)

--DanhMucThanhLy

alter table DanhMucThanhLy
add constraint FK_DMTL_NhaTL foreign key(MaNhaThanhLy) references NhaThanhLy(MaNhaThanhLy)

--KhungPhanLoai
alter table KhungPhanLoai
add constraint FK_KPL_NhomSach  foreign key(MaNhomSach) references NhomSach(MaNhomSach)



