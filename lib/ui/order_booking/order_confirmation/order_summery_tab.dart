import 'package:dms/ui/order_booking/order_confirmation/orderinfo_datagridsource.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OrderSummery extends StatefulWidget {
  const OrderSummery({Key? key}) : super(key: key);

  @override
  _OrderSummeryState createState() => _OrderSummeryState();
}

class _OrderSummeryState extends State<OrderSummery> {
  /// DataGridSource required for SfDataGrid to obtain the row data.
  late OrderInfoDataGridSource dataSource;

  late bool isWebOrDesktop;

  bool isLandscapeInMobileView = false;

  @override
  void initState() {
    super.initState();
    isWebOrDesktop = false;
    dataSource =
        OrderInfoDataGridSource(isWebOrDesktop: true, orderDataCount: 100);
  }

  @override
  void didChangeDependencies() {
    isLandscapeInMobileView = !isWebOrDesktop &&
        MediaQuery.of(context).orientation == Orientation.landscape;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: dataSource,
      columns: getColumns(),
      tableSummaryRows: getTableSummaryRows(),
      stackedHeaderRows: [
        StackedHeaderRow(
          cells: [
            StackedHeaderCell(
                columnNames: ["name"],
                child: const Expanded(child: Center(child: Text("asdf")))),
            StackedHeaderCell(
                columnNames: ["freight"],
                child: const Expanded(child: Center(child: Text("asdf1"))))
          ],
        ),
      ],
      columnWidthMode: isWebOrDesktop || isLandscapeInMobileView
          ? ColumnWidthMode.fill
          : ColumnWidthMode.auto,
      columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
    );
  }

  List<GridTableSummaryRow> getTableSummaryRows() {
    const Color color = Color(0xFF3B3B3B);
    return <GridTableSummaryRow>[
      GridTableSummaryRow(
          color: color,
          showSummaryInRow: true,
          title: 'Total Order Count: {count}',
          // titleColumnSpan: 2,
          columns: <GridSummaryColumn>[
            const GridSummaryColumn(
                name: 'price',
                columnName: 'price',
                summaryType: GridSummaryType.sum),
          ],
          position: GridTableSummaryRowPosition.top),
      GridTableSummaryRow(
          color: color,
          showSummaryInRow: false,
          columns: <GridSummaryColumn>[
            const GridSummaryColumn(
                name: 'freight',
                columnName: 'freight',
                summaryType: GridSummaryType.sum),
            const GridSummaryColumn(
                name: 'price',
                columnName: 'price',
                summaryType: GridSummaryType.sum),
          ],
          position: GridTableSummaryRowPosition.bottom),
    ];
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
        autoFitPadding: const EdgeInsets.all(8.0),
        width: (isWebOrDesktop) ? 120.0 : 100,
        columnName: 'id',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text(
            'Order ID',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        autoFitPadding: const EdgeInsets.all(8.0),
        width: (isWebOrDesktop) ? 150.0 : 100,
        columnName: 'customerId',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text(
            'Customer ID',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        autoFitPadding: const EdgeInsets.all(8.0),
        width: (isWebOrDesktop) ? 120.0 : double.nan,
        columnName: 'name',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Name',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        width: (isWebOrDesktop) || !isWebOrDesktop ? 140.0 : double.nan,
        columnName: 'freight',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerRight,
          child: const Text(
            'Freight',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        autoFitPadding: const EdgeInsets.all(8.0),
        width: (isWebOrDesktop) ? 120.0 : double.nan,
        columnName: 'city',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'City',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
          width: (isWebOrDesktop) || !isWebOrDesktop ? 120.0 : double.nan,
          columnName: 'price',
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: const Text(
              'Price',
              overflow: TextOverflow.ellipsis,
            ),
          ))
    ];
  }
}
