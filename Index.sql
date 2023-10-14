--Tình huống 3: Các nhóm sách được mượn đọc nhiều nhất và số lượng theo thứ tự
 --Tạo composite index trên thuộc tính ISBN và STT cảu bảng CT_PhieuMuon
 CREATE INDEX index_ISBN_STT
 ON CT_PhieuMuon(ISBN,STT)

 --Tình huống 4: Lập phiếu mượn sách 
--Tạo index trên thuộc tính MaKPL của bảng Sach
create index index_KPL on Sach(MaKPL)

--Tình huống 5: Lập phiếu trả sách
 --Tạo composite index trên thuộc tính ISBN và STT cảu bảng CT_PhieuTra
CREATE INDEX index_ISBN_STT
 ON CT_PhieuTra(ISBN,STT)