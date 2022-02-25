package kr.or.ddit.member.main;

import java.util.List;
import java.util.Scanner;

import kr.or.ddit.member.service.IMemberService;
import kr.or.ddit.member.service.MemberServiceImp1;
import kr.or.ddit.member.vo.MemberVO;

public class MemberMain {
	
	private Scanner scan = new Scanner(System.in); 
	
	private IMemberService memberService;
	
	public MemberMain(){
		memberService = new MemberServiceImp1();
	}
	
	/**
	 * 메뉴를 출력하는 메서드
	 */
	public void displayMenu(){
		System.out.println();
		System.out.println("----------------------");
		System.out.println("  === 작 업 선 택 ===");
		System.out.println("  1. 자료 입력");
		System.out.println("  2. 자료 삭제");
		System.out.println("  3. 자료 수정");
		System.out.println("  4. 전체 자료 출력");
		System.out.println("  5. 자료 검색");
		System.out.println("  6. 작업 끝.");
		System.out.println("----------------------");
		System.out.print("원하는 작업 선택 >> ");
	}
	
	/**
	 * 프로그램 시작메서드
	 */
	public void start(){
		int choice;
		do{
			displayMenu(); //메뉴 출력
			choice = scan.nextInt(); // 메뉴번호 입력받기
			switch(choice){
				case 1 :  // 자료 입력
					insertMember();
					break;
				case 2 :  // 자료 삭제
                    deleteMember();
					break;
				case 3 :  // 자료 수정
					updateMember();
					break;
				case 4 :  // 전체 자료 출력
		            displayMemberAll();	
					break;
				case 5 :  // 자료 검색 
                    searchMember();
					break;
				case 6 :  // 작업 끝
					System.out.println("작업을 마칩니다.");
					break;
				default :
					System.out.println("번호를 잘못 입력했습니다. 다시입력하세요");
			}
		}while(choice!=6);
	}


    /*
     * 전체 회원정보를 출력하는 메서드
     */
	private void displayMemberAll() {
		System.out.println();
		System.out.println("---------------------------");
		System.out.println("ID\t이름\t전화번호\t주소");
		System.out.println("---------------------------");

		List<MemberVO> memList = memberService.getAllMemberList();

		for (MemberVO mv : memList) {
			System.out.println(mv.getMemId() + "\t" + mv.getMemName() + "\t" + mv.getMemTel() + "\t" + mv.getMemAddr());
		}
		System.out.println("---------------------------");
		System.out.println("출력 작업 끝...");
	}

    /*
     * 회원정보를 삭제하기 위한 메서드
     */
    private void deleteMember(){
        System.out.println();
        System.out.println("삭제할 회원 정보를 입력하세요.");
        System.out.print("회원 ID >> ");

        String memId = scan.next();
        
        int cnt = memberService.deleteMember(memId);
        
        if(cnt > 0){
            System.out.println("삭제되었습니다.");

        }else {
            System.out.println("삭제실패!");
        }

    }
    /*
     * 회원정보를 수정하기 위한 메서드
     */
    private void updateMember(){
        boolean chk = false; // 중복 여부(존재 여부)

        String memId = "";

        do {
            System.out.println();
            System.out.println("수정할 회원정보를 입력하세요.");
            System.out.print("회원 ID >>");

            memId = scan.next();

            chk = checkMember(memId);

            if(chk == false){
                System.out.println("회원ID가 " + memId + "인 회원이 존재하지 않습니다.");
                System.out.println("다시 입력해 주세요.");
            }
        }while(chk == false);

        System.out.print("회원 이름 >> ");
        String memName = scan.next();

        System.out.print("회원 전화번호 >> ");
        String memTel = scan.next();

        scan.nextLine(); // 입력 버퍼 비우기
        System.out.print("회원 주소 >> ");
        String memAddr = scan.nextLine();
        
        MemberVO mv = new MemberVO();
        mv.setMemId(memId);
        mv.setMemName(memName);
        mv.setMemTel(memTel);
        mv.setMemAddr(memAddr);

        int cnt = memberService.updateMember(mv);
        
        if(cnt > 0){
            System.out.println(memId + "회원의 정보를 수정했습니다!");
        }else {
            System.out.println(memId + "회원 수정 작업 실패!");
        }
    }
	
	/**
	 * 회원정보 추가
	 */
	private void insertMember() {

        boolean chk = false; // 중복 여부(존재 여부)

        String memId = "";

        do {
            System.out.println();
            System.out.println("추가할 회원정보를 입력하세요.");
            System.out.print("회원 ID >>");

            memId = scan.next();

            chk = checkMember(memId);

            if(chk == true){
                System.out.println("회원ID가 " + memId + "인 회원이 존재합니다.");
                System.out.println("다시 입력해 주세요.");
            }
        }while(chk == true);

        System.out.print("회원 이름 >> ");
        String memName = scan.next();

        System.out.print("회원 전화번호 >> ");
        String memTel = scan.next();

        scan.nextLine(); // 입력 버퍼 비우기
        System.out.print("회원 주소 >> ");
        String memAddr = scan.nextLine();

        MemberVO mv = new MemberVO();
        mv.setMemId(memId);
        mv.setMemName(memName);
        mv.setMemTel(memTel);
        mv.setMemAddr(memAddr);
        
        int cnt = memberService.registerMember(mv);
        
        if(cnt > 0){
            System.out.println(memId + "회원 추가 작업 성공!");
        }else {
            System.out.println(memId + "회원 추가 작업 실패!");
        }
	}

    /**
     * 회원ID를 이용하여 회원이 있는지 알려주는 메서드
     * @param memId 회원ID
     * @return 회원이 존재하면 true, 존재하지 않으면  false
     */
    private boolean checkMember(String memId){

        boolean chk = false;

        chk = memberService.chkMember(memId);

        return chk;
    }

    /**
     */
    public void searchMember() {
        /*
         * 검색할 회원 ID, 회원이름, 전화번호, 주소 등을 입력하면
         * 입력한 정보만 사용하여 검색하는 기능을 구현하시오.
         * 주소는 입력한 값이 포함되어도 검색되도록 한다.
         * 입력을 하지 않을 자료는 엔터키로 다음 입력으로 넘긴다.
         */

        scan.nextLine();    //  입력버퍼 지우기

        System.out.println();
        System.out.println("검색할 정보를 입력하세요.");

        System.out.print("회원 ID >> ");
        String memId = scan.nextLine().trim();

        System.out.print("회원 이름 >> ");
        String memName = scan.nextLine().trim();

        System.out.print("회원 전화번호 >> ");
        String memTel = scan.nextLine().trim();

        System.out.print("회원 주소 >> ");
        String memAddr = scan.nextLine().trim();

        MemberVO mv = new MemberVO();
        mv.setMemId(memId);
        mv.setMemName(memName);
        mv.setMemTel(memTel);
        mv.setMemAddr(memAddr);
        
        List<MemberVO> memList = memberService.getSearchMember(mv);

		System.out.println();
		System.out.println("---------------------------");
		System.out.println("ID\t이름\t전화번호\t주소");
		System.out.println("---------------------------");

        if(memList.size() > 0){

            for (MemberVO mv2 : memList) {
                System.out.println(mv2.getMemId() + "\t" + mv2.getMemName() + "\t" + mv2.getMemTel() + "\t" + mv2.getMemAddr());
            }
        }else {
            System.out.println("검색된 결과가 존재하지 않습니다.");
        }
        System.out.println("---------------------------");
        System.out.println("검색결과 출력 작업 끝...");
    }


	public static void main(String[] args) {
		MemberMain memObj = new MemberMain();
		memObj.start();
	}

}
