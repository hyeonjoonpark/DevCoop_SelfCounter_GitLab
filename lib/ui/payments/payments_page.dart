import 'dart:convert';
import 'package:counter/dto/event_item_response_dto.dart';
import 'package:counter/controller/get_event_list.dart';
import 'package:counter/controller/payments_api.dart';
import 'package:counter/secure/db.dart';
import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:counter/ui/_constant/util/number_format_util.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../dto/item_response_dto.dart';
import '../_constant/component/button.dart';
import 'widgets/payments_popup.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({Key? key}) : super(key: key);

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  String savedStudentName = '';
  int savedPoint = 0;
  int totalPrice = 0;
  String savedCodeNumber = '';
  String eventStatus = '';
  List<ItemResponseDto> itemResponses = [];
  List<EventItemResponseDto> eventItemList = [];
  final dbSecure = DbSecure();
  String token = '';
  bool isButtonDisabled = false;

  TextEditingController barcodeController = TextEditingController();
  FocusNode barcodeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        savedPoint = prefs.getInt('point') ?? 0;
        savedStudentName = prefs.getString('studentName') ?? '';
        savedCodeNumber = prefs.getString('codeNumber') ?? '';
        token = prefs.getString('accessToken') ?? '';
      });
    } catch (e) {
      rethrow;
    }
  }

// 결제 후 남은 포인트를 팝업창에 띄우는 로직 추가
  void showPaymentsPopup(String message, bool isError) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return paymentsPopUp(context, message, isError);
      },
    );
  }

  Future<void> fetchItemData(String barcode, int quantity) async {
    try {
      String apiUrl = '${dbSecure.DB_HOST}/kiosk';
      final response = await http.get(
        Uri.parse('$apiUrl/itemSelect?barcodes=$barcode'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          final List<dynamic> itemJsonList =
              jsonDecode(utf8.decode(response.bodyBytes));
          final Map<String, dynamic> responseBody = itemJsonList.first;
          final String itemName = responseBody['name'];
          final dynamic rawItemPrice = responseBody['price'];
          final int itemQuantity = responseBody['quantity'];
          // Response Body에서 eventStatus를 가져옵니다.
          final String eventStatus = responseBody['eventStatus'];
          final String itemPrice = rawItemPrice.toString();

          final existingItemIndex = itemResponses.indexWhere(
            (existingItem) => existingItem.itemId == barcode,
          );

          if (existingItemIndex != -1) {
            final existingItem = itemResponses[existingItemIndex];
            existingItem.quantity += itemQuantity;
            totalPrice += existingItem.itemPrice * itemQuantity;
            itemResponses[existingItemIndex] = existingItem;
          } else {
            final item = ItemResponseDto(
              itemName: itemName,
              itemPrice: rawItemPrice,
              itemId: barcode,
              quantity: itemQuantity,
              type: eventStatus,
            );

            print("eventStatus = $eventStatus");
            itemResponses.add(item);

            eventStatus == 'NONE'
                ? totalPrice += int.parse(itemPrice) * itemQuantity
                : totalPrice +=
                    (int.parse(itemPrice) * itemQuantity / 2) as int;
          }
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  void addItem(String itemBarcode) {
    fetchItemData(itemBarcode, 1);
  }

  Future<void> _handlePayment() async {
    // onTap 콜백을 async로 선언하여 비동기 처리 가능
    if (savedPoint - totalPrice >= 0) {
      await payments(itemResponses);
    } else {
      showPaymentsPopup(
        "잔액이 부족합니다",
        true,
      );
    }
  }

  Function()? _debounce(Function()? func, int milliseconds) {
    bool isButtonPressed = false;

    return () {
      if (!isButtonPressed) {
        isButtonPressed = true;
        func?.call();
        Future.delayed(Duration(milliseconds: milliseconds), () {
          isButtonPressed = false;
        });
      }
    };
  }

  void handleBarcodeSubmit() {
    String barcode = barcodeController.text;

    int quantity = 1;

    if (barcode.isNotEmpty) {
      fetchItemData(
        barcode,
        quantity,
      );

      // 상품 선택 후 바코드 입력창 초기화
      barcodeController.clear();
    }
  }

  Future<void> payments(List<ItemResponseDto> items) async {
    try {
      String apiUrl = '${dbSecure.DB_HOST}/kiosk/executePayments';

      // API 요청 함수 호출
      final response = await executePaymentRequest(
          apiUrl, token, savedCodeNumber, savedStudentName, totalPrice, items);

      // 응답을 UTF-8로 디코딩하여 변수에 저장합니다.
      String responseBody = utf8.decode(response.bodyBytes);

      // JSON 파싱
      var decodedResponse = json.decode(responseBody);

      // 디코드된 응답을 출력합니다.

      if (response.statusCode == 200) {
        if (decodedResponse['status'] == 'success') {
          int remainingPoints = decodedResponse['remainingPoints'];
          String message =
              decodedResponse['message'] + "\n남은 잔액: $remainingPoints";
          showPaymentsPopup(
            message,
            false,
          );
        } else {
          showPaymentsPopup(
            decodedResponse['message'],
            true,
          );
        }
      } else {
        showPaymentsPopup(
          '에러: ${decodedResponse['message']}',
          true,
        );
      }
    } catch (e) {
      if (e is http.Response) {
        String responseBody = utf8.decode(e.bodyBytes);
        var decodedResponse = json.decode(responseBody);
        showPaymentsPopup(
          '예상치 못한 에러: ${decodedResponse['message']}',
          true,
        );
      } else {
        showPaymentsPopup(
          '예상치 못한 에러: ${e.toString()}',
          true,
        );
      }
    }
  }

  @override
  void dispose() {
    barcodeController.dispose();
    barcodeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(barcodeFocusNode);
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        body: GestureDetector(
          onTap: () {
            // 다른 곳을 탭하면 포커스 해제
            barcodeFocusNode.unfocus();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 50,
              horizontal: 90,
            ),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$savedStudentName 학생  |  $savedPoint 원',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Row(
                      children: [
                        SizedBox(
                          height: 60.0, // 원하는 높이로 조정
                          width: 300.0, // 원하는 너비로 조정
                          child: TextFormField(
                            onFieldSubmitted: (_) {
                              handleBarcodeSubmit();
                            },
                            controller: barcodeController,
                            focusNode: barcodeFocusNode,
                            decoration: const InputDecoration(
                              hintText: '상품 바코드를 입력해주세요',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        mainTextButton(
                          text: '상품선택',
                          onTap: () {
                            handleBarcodeSubmit();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                const Divider(
                  color: DevCoopColors.black,
                  thickness: 4,
                  height: 4,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                    ),
                    child: Column(
                      children: [
                        paymentsItem(
                          left: '상품 이름',
                          // ItemResponseDto의 Getter 사용
                          type: "이벤트",
                          center: '수량',
                          plus: "",
                          minus: "-",
                          rightText: '상품 가격',
                          contentsTitle: true,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                for (int i = 0;
                                    i < itemResponses.length;
                                    i++) ...[
                                  paymentsItem(
                                    left: itemResponses[i].itemName,
                                    // eventStatus가 'NONE'일 경우 'NONE'을 출력
                                    // eventStatus가 '1+1'일 경우 '1+1'을 출력
                                    type: itemResponses[i].type == 'NONE'
                                        ? '일 반'
                                        : '1 + 1',
                                    center: itemResponses[i].quantity,
                                    plus: "+",
                                    minus: "-",
                                    rightText:
                                        itemResponses[i].itemPrice.toString(),
                                    totalText: false,
                                  ),
                                  if (i < itemResponses.length - 1) ...[
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 4,
                  height: 4,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 40,
                      ),
                      child: savedPoint - totalPrice >= 0
                          ? paymentsItem(
                              left: '총 상품 개수 및 합계',
                              // ItemResponseDto의 Getter 사용
                              type: "",
                              center: itemResponses
                                  .map<int>((item) => item.quantity)
                                  .fold<int>(
                                      0,
                                      (previousValue, element) =>
                                          previousValue + element),
                              plus: "",
                              minus: "",
                              rightText:
                                  totalPrice.toString(), // 수정: 값을 String으로 변환
                            )
                          : const Text(
                              "잔액이 부족합니다",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        mainTextButton(
                          text: '행사상품',
                          onTap: () async {
                            await getEventList(
                                (List<EventItemResponseDto> newList) {
                              setState(() {
                                eventItemList = newList;
                              });
                            });

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    '행사상품 (1+1)',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  content: eventItemList.isEmpty
                                      ? const Text(
                                          '행사상품이 없습니다.',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          ),
                                        )
                                      : SingleChildScrollView(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.only(
                                                left: 50, right: 50),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 400, // 명확한 높이 지정
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: GridView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount:
                                                                  5, // 열당 항목 수
                                                              crossAxisSpacing:
                                                                  10, // 항목 간 가로 간격
                                                              mainAxisSpacing:
                                                                  10, // 항목 간 세로 간격
                                                              childAspectRatio:
                                                                  2 // 각 항목의 종횡비
                                                              ),
                                                      itemCount: eventItemList
                                                          .length, // 항목의 총 수
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                color: index %
                                                                            2 ==
                                                                        0
                                                                    ? DevCoopColors
                                                                        .primary
                                                                    : DevCoopColors
                                                                        .transparent,
                                                                child: ListTile(
                                                                  shape: Border
                                                                      .all(
                                                                    color: const Color(
                                                                        0xFFECECEC),
                                                                    width: 2,
                                                                  ),
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical:
                                                                        5.0,
                                                                    horizontal:
                                                                        10.0,
                                                                  ),
                                                                  title:
                                                                      SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    height: 500,
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            eventItemList[index].itemName,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.w900,
                                                                              color: Colors.black,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                          ),
                                                                          Text(
                                                                            "${eventItemList[index].itemPrice}원",
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w900,
                                                                              color: Colors.black,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            SizedBox(
                                                              width: 250,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  addItem(eventItemList[
                                                                          index]
                                                                      .barcode);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      WidgetStateProperty
                                                                          .all<
                                                                              Color>(
                                                                    Colors
                                                                        .black38,
                                                                  ),
                                                                  shape: WidgetStateProperty
                                                                      .all<
                                                                          RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        10,
                                                                      ),
                                                                      side:
                                                                          const BorderSide(
                                                                        width:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                  "+",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: DevCoopColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        30,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                  actions: <Widget>[
                                    mainTextButton(
                                      text: "닫기",
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        mainTextButton(
                          text: '전체삭제',
                          onTap: () {
                            setState(() {
                              itemResponses.clear();
                              totalPrice = 0;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        mainTextButton(
                          text: '처음으로',
                          onTap: () {
                            removeUserData();
                            Get.offAllNamed("/");
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        mainTextButton(
                          text: '계산하기',
                          isButtonDisabled: isButtonDisabled,
                          onTap: _debounce(() async {
                            setState(() {
                              isButtonDisabled = true;
                            });

                            await _handlePayment();

                            setState(() {
                              isButtonDisabled = true;
                            });
                          }, 5000), // 5초 동안 버튼 비활성화
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row paymentsItem({
    required String left,
    required String type,
    required dynamic center,
    required String plus,
    required String minus,
    int? right,
    String? rightText,
    bool contentsTitle = false,
    bool totalText = true,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: contentsTitle
                ? DevCoopTextStyle.medium_30.copyWith(
                    color: DevCoopColors.black,
                  )
                : totalText
                    ? DevCoopTextStyle.bold_30.copyWith(
                        color: DevCoopColors.black,
                      )
                    : DevCoopTextStyle.bold_30.copyWith(
                        color: DevCoopColors.black,
                      ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          // margin: const EdgeInsets.only(left: 40),
          alignment: Alignment.centerRight,
          width: 100,
          child: Text(
            type,
            style: contentsTitle
                ? DevCoopTextStyle.medium_30.copyWith(
                    color: DevCoopColors.black,
                  )
                : totalText
                    ? DevCoopTextStyle.medium_30.copyWith(
                        color: DevCoopColors.black,
                      )
                    : DevCoopTextStyle.medium_30.copyWith(
                        color: DevCoopColors.error,
                      ),
          ),
        ),
        Container(
          width: 155,
          alignment: Alignment.centerRight,
          child: Text(
            "$center",
            style: contentsTitle
                ? DevCoopTextStyle.medium_30.copyWith(
                    color: DevCoopColors.black,
                  )
                : totalText
                    ? DevCoopTextStyle.bold_30.copyWith(
                        color: DevCoopColors.black,
                      )
                    : DevCoopTextStyle.bold_30.copyWith(
                        color: DevCoopColors.black,
                      ),
          ),
        ),
        Container(
          width: 155,
          alignment: Alignment.centerRight,
          child:
              Text(rightText ?? NumberFormatUtil.convert1000Number(right ?? 0),
                  style: contentsTitle
                      ? DevCoopTextStyle.medium_30.copyWith(
                          color: DevCoopColors.black,
                        )
                      : totalText
                          ? DevCoopTextStyle.bold_30.copyWith(
                              color: DevCoopColors.black,
                            )
                          : DevCoopTextStyle.bold_30.copyWith(
                              color: DevCoopColors.black,
                            )),
        ),
        const SizedBox(width: 10),
        plus.isNotEmpty
            ? Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      itemResponses
                          .firstWhere((element) => element.itemName == left)
                          .quantity += 1;
                      // 상품 추가 버튼 클릭 시 상품 갯수 증가
                      totalPrice += itemResponses
                          .firstWhere((element) => element.itemName == left)
                          .itemPrice;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DevCoopColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: const BorderSide(
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    plus,
                    textAlign: TextAlign.center,
                    style: DevCoopTextStyle.bold_30.copyWith(
                      color: DevCoopColors.black,
                      fontSize: 30,
                    ),
                  ),
                ),
              )
            : const SizedBox(
                width: 54,
              ),
        const SizedBox(width: 10),
        plus.isNotEmpty
            ? Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      for (int i = 0; i < itemResponses.length; i++) {
                        if (itemResponses[i].itemName == left) {
                          if (itemResponses[i].quantity > 1) {
                            itemResponses[i].quantity -= 1;
                            break;
                          } else {
                            // 상품을 삭제하기 전에 가격을 임시 변수에 저장
                            var itemPrice = itemResponses[i].itemPrice;
                            itemResponses.removeAt(i);
                            // 삭제된 상품의 가격만큼 총 가격에서 빼기
                            totalPrice = (totalPrice - itemPrice) > 0
                                ? (totalPrice - itemPrice)
                                : 0;
                            break;
                          }
                        }
                      }

                      // 상품 삭제 버튼 클릭 시 상품 총 가격 감소
                      totalPrice > 0
                          ? totalPrice -= itemResponses
                              .firstWhere((element) => element.itemName == left)
                              .itemPrice
                          : totalPrice = 0;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DevCoopColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: const BorderSide(
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    minus,
                    textAlign: TextAlign.center,
                    style: DevCoopTextStyle.bold_30.copyWith(
                      color: DevCoopColors.black,
                      fontSize: 30,
                    ),
                  ),
                ),
              )
            : const SizedBox(
                width: 54,
              ),
      ],
    );
  }
}
