/*
 * 21/09/01 
 * author : Lee KwangHyo
 * 은행의 입출금을 스레드로 처리하는 예제
 * (Synchronized를 이용한 동기화 처리)
 */

package kr.or.ddit.basic;

public class T16_SyncAccountTest {
    public static void main(String[] args) {
        SyncAccount sAcc = new SyncAccount();
        sAcc.setBalance(10000);

        BankThread bt1 = new BankThread(sAcc);
        BankThread bt2 = new BankThread(sAcc);

        bt1.start();
        bt2.start();
    }

}

// 은행의 입출금을 관리하는 클래스 정의
class SyncAccount {
    private int balance; // 잔액이 저장될 변수

    public synchronized int getBalance(){
        return balance;
    }
    public void setBalance(int balance){
        this.balance = balance;
    }

    // 입금 처리를 수행하는 메서드
    public void deposit(int money){
        this.balance += money;
    }

    // 출금을 처리하는 메서드 (출금 성공 : true, 출금 실패 : false 반환)
    // 동기화 영역에서 호출하는 메서드도 동기화 처리를 해 주어야 한다.
    public synchronized boolean withdraw(int money){
        if(balance >= money){
            for(int i=1; i<1000000000; i++){} // 시간 때우기용

            balance -= money; // 출금하기

            System.out.println("메서드 안에서 balance = "
                    + getBalance());
            // 동기화처리된 메서드 안에서 사용하는 메서드는
            // 동기화가 되어있지 않기 때문에 예기치 못한 일이 일어날 수 있다
            // 그러므로 동기화를 꼼꼼하게 하기 위해서는 동기화처리된 메서드에서 사용하는 메서드를 찾아서
            // 동기화해 주어야 한다(여기서는 getBalance())
            return true; // 출금성공
        }else{
            return false; // 출금 실패
        }
    }
}

// 은행 업무를 처리하는 스레드
class BankThread extends Thread {
    private SyncAccount sAcc;

    @Override
    public void run(){
        boolean result = sAcc.withdraw(6000); // 6000원 인출
        System.out.println("스레드 안에서 result = " + result
                + ", balance = " + sAcc.getBalance());
    }

    BankThread(SyncAccount sAcc){
        this.sAcc = sAcc;
    }
}
