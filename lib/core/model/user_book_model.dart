class UserBookModel{
  final String userId;
  final String bookId;
  String? baslangicTarihi;
  String? bitisTarihi;
  bool isFinished;
  List<String>? bookNote;

  UserBookModel({required this.userId, required this.bookId, this.baslangicTarihi, this.bitisTarihi,this.isFinished = false,this.bookNote});
}