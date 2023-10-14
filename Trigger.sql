-- ràng buộc
-- Khi tạo phiếu mượn sách thì tình trạng của sách là đã mượn (đã xét trong proc mượn sách ) 
-- báo, tạp chí, sách tham khảo thì không thể mượn về nhà ( đã xét trong proc mượn sách)


-- tiền phạt trả sách trễ 
create trigger trigger_TienPhatTraSachQuaHan
on PhieuTra
for insert 
as
begin
	declare @ngaytra datetime = (select NgayLapPhieu from inserted)
	declare @ngaymuon datetime = (select m.NgayLapPhieu from inserted i, PhieuMuon m where i.SoPhieuMuon=m.SoPhieuMuon)
	declare @songaymuon tinyint = Datediff(day,@ngaymuon,@ngaytra)
	declare @thoihan tinyint =(select ThoiHan from inserted i, PhieuMuon m where i.SoPhieuMuon=m.SoPhieuMuon)
	if(@songaymuon>@thoihan )
	begin
		declare @songayquahan tinyint= @songaymuon-@thoihan
		declare @tienphat money
		if(@songayquahan<=30)
			set @tienphat=@songayquahan*1000
		if(@songayquahan>30)
			set @tienphat=@songayquahan*2000
		declare @sophieutra nchar(10) = (select SoPhieuTra from inserted )
		update PhieuTra
		set SoTienPhat= @tienphat
		where SoPhieuTra=@sophieutra
			
	end

end
go

-- khi trả sách, tiền phạt từng cuốn sách sẽ được cộng vào số tiền phạt trong Phiếu trả
create trigger trigger_TienPhat
on CT_PhieuTra
after insert, update
as
begin
	if exists (select * from inserted where TienPhat is not null)
		begin
			declare @sophieutra nchar(10) = (select SoPhieuTra from inserted )
			declare @tienphat money = (select TienPhat from inserted )
			update PhieuTra
			set SoTienPhat=SoTienPhat+@tienphat 
			where SoPhieuTra=@sophieutra
		end
end
go
-- khi một sách được thanh lí thì tình trạng của sách là 'Đã thanh lí'  ( nếu proc chưa có cập nhật thì dùng trigger này)
create trigger trigger_ThanhLiSach
on CT_DMTL_BanSaoLuu
after insert, update
as
begin
	declare @isbn nchar(10)= (select ISBN from inserted)
	declare @stt int= (select STT from inserted)
    update BanSaoLuu
	set TinhTrang =N'Đã thanh lí'
	where ISBN=@isbn and STT=@stt
end
go
-- khi tạo, xóa, cập nhật một CT_PhieuMuon thì cập nhật lại số lượng sách mượn trong Phiếu mượn đó
create trigger trigger_SoLuongSachMuon
on CT_PhieuMuon
after insert, update, delete
as
begin
	declare @sophieumuon nchar(10) 
	if not exists(select * from inserted) -- delete
		begin
			set @sophieumuon = (select SoPhieuMuon from deleted )
			update PhieuMuon
			set SoLuong=SoLuong-1
			where SoPhieuMuon=@sophieumuon
		end
	else 
	begin
		if not exists(select * from deleted) -- insert
		begin
			set @sophieumuon = (select SoPhieuMuon from inserted )
			update PhieuMuon
			set SoLuong=SoLuong+1
			where SoPhieuMuon=@sophieumuon
		end
		else -- update
		begin
			if update(SoPhieuTra)
			begin 
				set @sophieumuon=(select SoPhieuMuon from inserted )
				declare @sophieumuoncu nchar(10)= (select SoPhieuMuon from deleted )
				update PhieuMuon
				set SoLuong=SoLuong-1
				where SoPhieuMuon=@sophieumuoncu
				update PhieuMuon
				set SoLuong=SoLuong+1
				where SoPhieuMuon=@sophieumuon			
			end
		end
	end
end

go
-- khi tạo, xóa, cập nhật một CT_PhieuTra thì cập nhật lại số lượng sách trả trong PhieuTra tương ứng 
create trigger trigger_SoLuongSachTra
on CT_PhieuTra
after insert, update, delete
as
begin
	declare @sophieutra nchar(10) 
	if not exists(select * from inserted) -- delete
		begin
			set @sophieutra = (select SoPhieuTra from deleted )
			update PhieuTra
			set SoLuong=SoLuong-1
			where SoPhieuTra=@sophieutra
		end
	else 
	begin
		if not exists(select * from deleted) -- insert
		begin
			set @sophieutra = (select SoPhieuTra from inserted )
			update PhieuTra
			set SoLuong=SoLuong+1
			where SoPhieuTra=@sophieutra
		end
		else -- update
		begin
			if update(SoPhieuTra)
			begin 
				set @sophieutra=(select SoPhieuTra from inserted )
				declare @sophieutracu nchar(10)= (select SoPhieuTra from deleted )
				update PhieuTra
				set SoLuong=SoLuong-1
				where SoPhieuTra=@sophieutracu
				update PhieuTra
				set SoLuong=SoLuong+1
				where SoPhieuTra=@sophieutra			
			end
		end
	end
end



---------------------
go
-- khi trả sách : nếu tình trạng trong phiếu trả là 'Đã mất' hoặc 'Hư hỏng' thì tình trạng của sách đó được cập nhật theo, còn nếu tình trạng trong phiếu trả là bình thường thì tình trạng sách cập nhật là 'Có sẵn' để tiếp tục cho mượn
create trigger trigger_TinhTrangBanSaoLuu
on CT_PhieuTra
after insert
as
begin
	declare @tinhtrang nvarchar(50)= (select TinhTrang from inserted)
	if (@tinhtrang = N'Hư hỏng' or @tinhtrang = N'Đã mất')
		begin
			declare @isbn nchar(10)=(select ISBN from inserted)
			declare @stt int=(select STT from inserted)
			update BanSaoLuu
			set TinhTrang= @tinhtrang
			where ISBN=@isbn and STT=@stt
		end

	else 
		begin
			update BanSaoLuu
			set TinhTrang= N'Có sẵn'
			where ISBN=@isbn and STT=@stt
		end

end

go

-- thời hạn của phiếu mượn là 2 tuần hoăc 3 tuần (nếu xin gia hạn) từ thời gian mượn
create trigger trigger_ThoiHanMuonSach 
on PhieuMuon
for insert, update
as
begin
	if exists (select * from inserted where ThoiHan > 21)
	begin
	   raiserror(N'Lỗi: Thời hạn mượn sách tối đa là 3 tuần!!!',16,1)
	   rollback
	end
end

-- số lượng sách mượn đối đa 2 cuốn 1 lần 
go
create trigger trigger_SoLuongSachMuonDoiDa 
on CT_PhieuMuon
for insert, update
as
begin
	if exists (select * from inserted i, PhieuMuon p where i.SoPhieuMuon = p.SoPhieuMuon and p.SoLuong=2)
	begin
			raiserror (N'Lỗi: Mỗi lần chỉ được mượn tối đa 2 cuốn sách',16,1)
			rollback
	end
end
go

-- Cuốn sách trả phải là cuốn sách đã được mượn
create trigger trigger_TraSach
on CT_PhieuTra
for insert, update
as
begin
	if not exists (select * from inserted i, BanSaoLuu b where i.ISBN=b.ISBN and i.STT = b.STT and b.TinhTrang=N'Có sẵn')
	begin
			raiserror (N'Lỗi: Không thể tạo Phiếu trả sách vì cuốn sách này chưa được mượn. Vui lòng kiểm tra lại',16,1)
			rollback
	end
end

go

-- Một phiếu trả chỉ trả cho một phiếu mượn, cuốn sách trả phải có trong danh sách những cuốn sách được mượn trong phiếu mượn đó
create trigger trigger_PhieuTra_PhieuMuon
on CT_PhieuTra
for insert, update
as
begin
	if not exists (select * from inserted i, PhieuTra t, CT_PhieuMuon m where i.SoPhieuTra=t.SoPhieuTra and t.SoPhieuMuon =m.SoPhieuMuon and i.ISBN=m.ISBN and i.STT= m.STT)
	begin
			raiserror (N'Lỗi: Cuốn sách này không có trong danh sách sách của phiếu mượn. Vui lòng kiểm tra lại',16,1)
			rollback
	end
end
go

--Nếu Đọc giả đã bị truất quyền thì không thể mượn sách 
create trigger trigger_TruatQuyenDG
on PhieuMuon
for insert
as
begin
	if exists (select * from inserted i, DocGia d where i.MaDocGia=d.MaDocGia and d.TinhTrang=N'Đã truất quyền')
	begin
			raiserror (N'Lỗi: Thẻ đã bị truất quyền đọc giả',16,1)
			rollback
	end

end

GO