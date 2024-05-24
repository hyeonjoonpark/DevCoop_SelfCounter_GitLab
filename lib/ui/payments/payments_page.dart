import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:counter/controller/payments_api.dart';
import 'package:counter/secure/db.dart';
import 'package:counter/ui/_constant/theme/devcoop_colors.dart';
import 'package:counter/ui/_constant/theme/devcoop_text_style.dart';
import 'package:counter/ui/_constant/util/number_format_util.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Dto/item_response_dto.dart';
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
  String? savedCodeNumber;
  List<ItemResponseDto> itemResponses = [];
  final player = AudioPlayer();
  final dbSecure = DbSecure();
  String token = '';

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
        savedCodeNumber = prefs.getString('codeNumber'); // 수정
        token = prefs.getString('accessToken') ?? ''; // 수정
      });

      if (savedPoint != 0 && savedStudentName.isNotEmpty) {
        print("Getting UserInfo");
        print('Data loaded from SharedPreferences');
      }

      if (savedCodeNumber == null) {
        print('codeNumber가 설정되지 않았습니다.');
      }
    } catch (e) {
      print('Error during loading data: $e');
    }
  }

  // fetchItemData 함수에서 ItemResponseDto 생성자 호출 시 itemId 추가
  Future<void> fetchItemData(String barcode, int quantity) async {
    try {
      print(token);
      String apiUrl = 'http://${dbSecure.DB_HOST}/kiosk';
      final response = await http.get(
        Uri.parse('$apiUrl/itemSelect?barcodes=$barcode'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // 수정: 토큰을 헤더에 추가하여 인증된 요청을 보냅니다.
        },
      );
      print('token : $token');
      print('headers : ${response.headers.toString()}');

      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> itemJsonList =
            jsonDecode(utf8.decode(response.bodyBytes));
        final Map<String, dynamic> responseBody = itemJsonList.first;
        final String itemName = responseBody['name'];
        final dynamic rawItemPrice = responseBody['price'];
        final String itemPrice =
            rawItemPrice?.toString() ?? '0'; // 수정: null 체크 및 기본값 설정

        setState(() {
          final existingItemIndex = itemResponses.indexWhere(
            (existingItem) => existingItem.itemId == barcode,
          );

          print(existingItemIndex);

          if (existingItemIndex != -1) {
            // 이미 추가된 아이템이 있다면 갯수를 증가시키고 총 가격 업데이트
            final existingItem = itemResponses[existingItemIndex];
            existingItem.quantity += 1;
            totalPrice += existingItem.itemPrice;
            itemResponses[existingItemIndex] = existingItem; // 업데이트된 아이템 다시 저장
          } else {
            // 새로운 아이템 추가
            final item = ItemResponseDto(
              itemName: itemName,
              itemPrice: int.parse(itemPrice),
              itemId: barcode,
              quantity: 1, // 새로운 아이템의 기본 갯수는 1로 설정
            );
            itemResponses.add(item);
            utf8.encode(itemResponses.toString());
            print(itemResponses);
            totalPrice += int.parse(itemPrice);
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

// 결제 후 남은 포인트를 팝업창에 띄우는 로직 추가
  void showPaymentsPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return paymentsPopUp(context, message);
      },
    );
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
    print('payments 함수가 호출되었습니다.');
    print("items = ${items[0].itemName}");
    try {
      print("savedUserId : $savedCodeNumber");
      if (savedCodeNumber != null) {
        String apiUrl = 'http://${dbSecure.DB_HOST}/kiosk/executePayments';

        print(apiUrl);
        print(
            "request user : $savedCodeNumber - $savedStudentName - $totalPrice");

        // API 요청 함수 호출
        final response = await executePaymentRequest(apiUrl, token,
            savedCodeNumber!, savedStudentName, totalPrice, items);
        print(response);

        print('token : $token');

        // utf8.decode를 사용하여 디코드한 결과를 변수에 저장합니다.
        String decodedResponse = utf8.decode(response.bodyBytes);
        print(decodedResponse);

        // 디코드된 응답을 출력합니다.
        print("-----------------");
        print(decodedResponse);

        if (response.statusCode == 200) {
          print("응답상태 : ${response.statusCode}");
          showPaymentsPopup(context, decodedResponse);
        } else {
          print("응답상태 : ${response.statusCode}");
          showPaymentsPopup(context, 'Error: $decodedResponse');
        }
      }
    } catch (e) {
      print('결제 처리 중 오류가 발생했습니다: $e');
      showPaymentsPopup(context, 'An unexpected error occurred: $e');
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
    return Scaffold(
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
                      Container(
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
                color: Colors.black,
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 40,
                      ),
                      child: savedPoint - totalPrice >= 0
                          ? paymentsItem(
                              left: '총 상품 개수 및 합계',
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
                          onTap: () async {
                            print("계산하기 버튼 클릭");
                            print("itemResponses : $itemResponses[0]");
                            // onTap 콜백을 async로 선언하여 비동기 처리 가능
                            if (savedPoint - totalPrice >= 0) {
                              await payments(itemResponses);
                            } else {
                              showPaymentsPopup(context, "잔액이 부족합니다");
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row paymentsItem({
    required String left,
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
                : !totalText
                    ? DevCoopTextStyle.light_30.copyWith(
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
          width: 155,
          alignment: Alignment.centerRight,
          child: Text(
            "$center",
            style: contentsTitle
                ? DevCoopTextStyle.medium_30.copyWith(
                    color: DevCoopColors.black,
                  )
                : !totalText
                    ? DevCoopTextStyle.light_30.copyWith(
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
          child: Text(rightText ?? NumberFormatUtil.convert1000Number(right!),
              style: contentsTitle
                  ? DevCoopTextStyle.medium_30.copyWith(
                      color: DevCoopColors.black,
                    )
                  : !totalText
                      ? DevCoopTextStyle.light_30.copyWith(
                          color: DevCoopColors.black,
                        )
                      : DevCoopTextStyle.bold_30.copyWith(
                          color: DevCoopColors.black,
                        )),
        ),
        SizedBox(width: 10),
        plus != ""
            ? Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    print("plus");
                    setState(() {
                      // TODO : 상품 추가 버튼 클릭 시 상품 갯수 증가

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
                    "$plus",
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
        plus != ""
            ? Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    print("minus");
                    setState(() {
                      // TODO : 상품 삭제 버튼 클릭 시 상품 총 갯수 감소

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
                    "$minus",
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
