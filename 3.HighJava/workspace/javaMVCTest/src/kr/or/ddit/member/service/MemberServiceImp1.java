package kr.or.ddit.member.service;

import java.util.List;

import kr.or.ddit.member.dao.IMemberDao;
import kr.or.ddit.member.dao.MemberDaoImp1;
import kr.or.ddit.member.vo.MemberVO;

public class MemberServiceImp1 implements IMemberService{

    // 사용할 DAO의 객체변수를 선언한다.
    private IMemberDao memDao;

    public MemberServiceImp1() {
        memDao = new MemberDaoImp1();
    }
	@Override
	public int registerMember(MemberVO mv) {
        
        int cnt = memDao.insertMember(mv);

        // 회원등록 관련 로그 남김

        // 관리자에게 메일 발송..

		return cnt;
	}

	@Override
	public boolean chkMember(String memId) {
		
		return memDao.chkMember(memId);
	}

	@Override
	public List<MemberVO> getAllMemberList() {
		return memDao.getAllMemberList();
	}

	@Override
	public int updateMember(MemberVO mv) {
		return memDao.updateMember(mv);
	}

	@Override
	public int deleteMember(String memId) {
		return memDao.deleteMember(memId);
	}
	@Override
	public List<MemberVO> getSearchMember(MemberVO mv) {
		return memDao.getSearchMember(mv);
	}

}
