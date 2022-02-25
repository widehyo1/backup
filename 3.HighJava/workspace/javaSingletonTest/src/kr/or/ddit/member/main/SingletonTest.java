package kr.or.ddit.member.main;

import kr.or.ddit.basic.MySingleton;

public class SingletonTest {
    public static void main(String[] args) {

        // My Singleton test1 = new MySingleton();  //  new 명령 사용 불가
        // getInstance()메서드를 이용하여 객체 생성
        MySingleton test2 = MySingleton.getInstance();
        test2.displayText();

        MySingleton test3 = MySingleton.getInstance();

        System.out.println("test2 => " + test2);
        System.out.println("test3 => " + test3);

        System.out.println(test2.equals(test3));
    }
}
