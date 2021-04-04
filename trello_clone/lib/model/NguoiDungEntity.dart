import 'package:floor/floor.dart';

@entity
class NguoiDung
{
  @primaryKey
  int taikhoan;

  @ColumnInfo(name: 'mat khau', nullable: false)
  String matkhau;

  @ColumnInfo(name: 'ten nguoi dung', nullable: false)
  String tennguoidung;

  @ColumnInfo(name: 'anh', nullable: true)
  uri avatar;
  NguoiDung(this.taikhoan, this.matkhau, this.tennguoidung, this.avatar);
}