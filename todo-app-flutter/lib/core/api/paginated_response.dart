class PaginationMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['total_pages'],
    );
  }
}

class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta meta;

  PaginatedResponse({
    required this.data,
    required this.meta,
  });

  factory PaginatedResponse.fromJson({
    required List data,
    required Map<String, dynamic> meta,
    required T Function(dynamic) mapper,
  }) {
    return PaginatedResponse<T>(
      data: data.map(mapper).toList(),
      meta: PaginationMeta.fromJson(meta),
    );
  }
}